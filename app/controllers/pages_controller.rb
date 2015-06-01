class PagesController < ApplicationController
  layout "splash_layout"

  def index
  end

  def show
    url = params.require(:url)
    Discussion.create(url) unless Discussion.exists?(url)

    @discussion = Discussion.new(url)
  end

  def status
    @discussion = Discussion.new(params.require :url)


    respond_to do |format|
      format.json {render :json => {:status => @discussion.get("status")}}
    end
  end

  def refresh
    url = params.require(:url)
    Discussion.recreate url
    redirect_to action: "show", url: url
  end

end
