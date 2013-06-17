# encoding: UTF-8

class Qa::RepliesController < QaController

  def index
  end

  def create
    (render :nothing => true; return false) if params[:content].blank?

    @topic = QATopic.find(params[:topic_id])
    @reply = QAReply.create(default_data.merge(:topic_id => @topic.id))

    @replies = @topic.replies.map {|reply| reply.content = reply._content_markdown_cache; reply }
    @topic.update_attributes :replies_count => @replies.count
    @topic.content = @topic._content_markdown_cache # after update_attributes

    respond_to do |format|
      format.json { render :json => {:topic => @topic, :replies => @topic.replies}, :status => 200}
    end
  end

end
