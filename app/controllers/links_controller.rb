class LinksController < ApplicationController

  def index
    @links = Link.all.reverse
    @link = Link.new
    @shortened_link = params[:shortened_link]
  end

  def show
    existing_link = Link.where(title: params[:link]).first
    if existing_link
      Link.increment_counter :hits, existing_link.id
      redirect_to existing_link.url
    else
      redirect_to root_path, alert: "The requested link doesn't exist"
    end
  end

  def create
    if Link.url_exists?(params[:link][:url])
      @shortened_link = "#{request.protocol}#{request.host_with_port}/#{Link.existing_link(params[:link][:url])}"
      redirect_to root_path({shortened_link: @shortened_link}), flash: {info: "Your shortened link already exists"}
    else
      @link = Link.build_link(params[:link][:url], params[:link][:title])

      respond_to do |format|
        if @link.save
          @shortened_link = "#{request.protocol}#{request.host_with_port}/#{@link.title}"
          format.html { redirect_to root_path({shortened_link: @shortened_link}), flash: {success: "Your shortened link was created successfully"} }
          format.json { render :json => @link.to_json }
        else
          format.html { redirect_to root_path, alert: @link.errors.full_messages.to_sentence }
          format.json {render :json => {error: "unprocessable entity"}.to_json }
        end
      end
    end
  end

  def destroy
    redirect_to root_path, flash: {warning: "The link has been deleted"}
  end

end
