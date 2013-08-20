class Link < ActiveRecord::Base
  attr_accessible :url, :title

  validates :url, uniqueness: true
  validates :url, :format => URI::regexp(%w(http https))
  validates :url, presence: true

  # Generates a 6-digit unique code for links
  #
  # Returns the alphanumeric 6-digit code
  def self.generate_code
    code = SecureRandom.hex(3)
    while !Link.where(title: code).blank?
      code = SecureRandom.hex(3)
    end
    return code
  end

  # Creates the Link instance with the given title or a generated token
  #
  # url - the String of the URL to link to
  # title - the String alias of the shortened URL
  #
  # Creates the Link object with the given attributes
  def self.create_link(url, title = "")
    processed_title = title.to_s.gsub(" ","")
    processed_title = Link.generate_code if title.blank?

    Link.create(url: url, title: processed_title) if Link.valid_url?(url)
  end

  # Verifies if a url is in the right format
  #
  # url - the String representation of the URL.
  #
  # Returns true if it is a valid HTTP or HTTPS url
  def self.valid_url?(url)
    uri = URI.parse(url)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end

end
