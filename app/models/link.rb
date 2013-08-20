class Link < ActiveRecord::Base
  attr_accessible :url, :title

  validates :url, :title, uniqueness: true
  validates :url, presence: true
  validate  :validate_url

  # =================================================
  # ================ Class methods ==================
  # =================================================

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
  def self.build_link(url, title = "")
    processed_title = title.to_s.gsub(" ","")
    processed_title = Link.generate_code if title.blank?

    link = Link.new(url: url, title: processed_title)

    if url_exists?(url)
      Link.where(url: url).first
    else
      link
    end
  end

  # Determines if a URL has previously been saved
  #
  # url - the String URL to verify
  #
  # Returns true if that exact URL has been saved before
  def self.url_exists?(url)
    !Link.where(url: url).blank?
  end

  # Determines if a title (alias) has previously been used
  #
  # title - the String alias of the URL to verify
  #
  # Returns true if that exact title has been used before
  def self.title_exists?(title)
    !Link.where(title: title).blank?
  end

  # Finds the link that has been created with a given URL
  #
  # url - the String url of the link to search
  #
  # Returns the title of the link that matches the URL provided
  def self.existing_link(url)
    Link.where(url: url).first.title
  end

  # =================================================
  # ============== Instance methods =================
  # =================================================

  # Verifies if a url is in the right format
  #
  # Adds errors to the object if it has an invalid url
  def validate_url
    uri = URI.parse(self.url)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    self.errors.add(:url, "is not in the right format")
  rescue URI::InvalidURIError
    self.errors.add(:url, "is not in the right format")
  end
end
