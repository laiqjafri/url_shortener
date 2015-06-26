class UrlsController < ApplicationController
  before_filter :load_urls, :only => [:index]
  def index
    @url = Url.new
    load_new_url
  end

  def create
    @url = Url.new url_params
    if @url.save
      session[:new_id] = @url.id
      redirect_to root_path
    else
      load_urls
      render :action => 'index'
    end
  end

  def show
    @url = Url.find_by key: params[:key]
    return redirect_to(@url.url) if @url.present?
    redirect_to root_url, :flash => {:danger => "No such entry in our system"}
  end

  private
  def url_params
    params.require(:url).permit(:url)
  end

  def load_urls
    @urls = Url.order('id desc').paginate :per_page => Url::ITEMS_PER_PAGE, :page => params[:page]
  end

  def load_new_url
    if session[:new_id].present?
      @new_url = Url.find_by_id(session[:new_id])
      session[:new_id] = nil
    end
  end
end
