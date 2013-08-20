class LinksController < ApplicationController

  def index
    @links = Link.all
    @link = Link.new
    @shortened_link = params[:shortened_link]
  end

  def show
    redirect_to Link.where(title: params[:link]).first.url
  end

  def create
    full_url = params[:prefix] + params[:link][:url]
    if Link.url_exists?(full_url)
      @shortened_link = "#{request.protocol}#{request.host_with_port}/#{Link.existing_link(full_url)}"
      redirect_to root_path({shortened_link: @shortened_link}), notice: "Your shortened link already exists"
    else
      @link = Link.build_link(full_url, params[:link][:title])

      respond_to do |format|
        if @link.save
          @shortened_link = "#{request.protocol}#{request.host_with_port}/#{@link.title}"
          format.html { redirect_to root_path({shortened_link: @shortened_link}), notice: "Your shortened link was created successfully" }
          format.json { render :json => @link.to_json }
        else
          format.html { redirect_to root_path, alert: @link.errors.full_messages.to_sentence }
          format.json {render :json => {error: "unprocessable entity"}.to_json }
        end
      end
    end
  end

end
