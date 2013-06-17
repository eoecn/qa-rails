# encoding: UTF-8

class QaController < ApplicationController
  before_filter do
    (render :nothing => true, :status => 403; return false) if user_login?
    # TODO auth user in category_id
  end

  private
  def default_data
    {:uid => current_user.uid, :uname => current_user.uname, :content => params[:content]}
  end

  def fetch_topic_list
    self.formats = [:html]
    @paginate_html = render_to_string(:partial => "qa/paginate")
    self.formats = [:json]

    @topics = QATopic.where(:category_id => params[:category_id]).order("created_at DESC").page(params[:page] || 1).per(params[:per] || 5)
    @topics.map do |topic|
      topic.content = topic._content_markdown_cache
    end

    respond_to do |format|
      format.json { render :json => {:topics => @topics.as_json(:methods => [:last_reply]), :paginate_html => @paginate_html}, :status => 200}
    end
  end

  def user_login?
    current_user.uid.to_i.zero?
  end


end
