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
    @tweets= Topic.find(params[:id]).tweets.map{ |t| {sentiment: t.sentiment,reply_to: t.reply_to,id: t.twitter_id,color: "lightblue",text: t.text.gsub("\n","<br>").gsub("\r","<br>")}}
    
    @positive=0
    @neutral=0
    @negative=0
    @nothing=0
   
    @tweets.each do |tweet|
        changed=false
        @nothing+=1

            
        if tweet[:reply_to] == nil
             tweet[:reply_to]=@topic.title
        else
            tweet[:reply_to]=tweet[:reply_to].twitter_id
        end


        if tweet[:sentiment] == 'positive'
            @positive+=1
            @nothing-=1
            tweet[:color]= "green"
            next
        end
        if tweet[:sentiment] =='neutral'
            @neutral+=1
            @nothing-=1
            tweet[:color]= "yellow"
            next
        end
        if tweet[:sentiment] =='negative'
            @negative+=1
            @nothing-=1
            tweet[:color]= "red"
            next
        end

    
    end
  end

  def tweets
    topic = Topic.find(params[:id])   
    @tweets = topic.tweets
    respond_to do |format|
      format.json { render json: @tweets }
    end
  end
  
end
