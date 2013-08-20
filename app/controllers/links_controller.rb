class LinksController < ApplicationController

  def index
    @links = Link.all
    @link = Link.new
  end

  def show
  end

  def destroy
  end

  def edit
  end

  def update
  end

  def create
    full_url = params[:prefix] + params[:link][:url]
    flash[:alert] = "URL is not valid" unless Link.valid_url?(full_url)

    @link = Link.create_link(full_url, params[:link][:title])
    flash[:notice] = "Short link successfully created" if @link

    redirect_to root_path
  end

end
