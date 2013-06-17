# encoding: UTF-8

class Qa::TopicsController < QaController

  def index
    @qa_options = {:category_id => params[:category_id]}

    fetch_topic_list
  end

  def create
    (render :nothing => true; return false) if (params[:title].blank? || params[:content].blank?)

    @topic = QATopic.create(default_data.merge(:title => params[:title], :category_id => params[:category_id]))

    fetch_topic_list
  end

  def show
    @topic = QATopic.find(params[:id])
    QATopic.increment_counter :view_count, @topic.id
    @topic.view_count += 1
    @topic.content = @topic._content_markdown_cache
    @replies = @topic.replies.map {|reply| reply.content = reply._content_markdown_cache; reply }

    respond_to do |format|
      format.json { render :json => {:topic => @topic, :replies => @replies}, :status => 200}
    end
  end

  def destroy
  end

  def new_topics_count
    @new_topcis_count = QATopic.where(:category_id => params[:category_id]).where("created_at >= ?", Time.at(params[:time_begin].to_i)).count

    respond_to do |format|
      format.json { render :json => {:new_topcis_count => @new_topcis_count}, :status => 200 }
    end
  end

end
