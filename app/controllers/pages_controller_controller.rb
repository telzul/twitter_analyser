class PagesControllerController < ApplicationController
  layout "splash_layout"

  def index
  end

  def search
    url = params[:q]

  end
end
