class DiscussionController < AplicationController

  def index
    @discussion = Discussion.new(params[:url])
  end

  def status
    @discussion = Discussion.new(params[:url])

    respond_to do |format|
      format.json {render :json => @discussion.status}
    end
  end

end