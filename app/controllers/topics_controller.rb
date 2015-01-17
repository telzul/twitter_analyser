class TopicsController < ApplicationController

  def new
    @topic = Topic.new()
  end
  
  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      redirect_to
    else
      render "new"
    end
  end
  
  def index
    @topics = Topic.all.map { |t| {id: t.id, title: t.title} }
  end

  def show
    @topic = Topic.find(params[:id])
    
  end

  def tweets
    topic = Topic.find(params[:id])
    @tweets = topic.tweets
    respond_to do |format|
      format.json { render json: @tweets }
    end
  end
  
end
