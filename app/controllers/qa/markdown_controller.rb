# encoding: UTF-8

class Qa::MarkdownController < QaController
  # 接口参数，接受一个data键值，以POST form形式提交，例如
  # data = 'markdown document'
  def create
    @success = false
    begin
      if params[:data].blank?
        @data = "data参数不能为空"
      else
        @data = "<div class='markdown'>#{MarkdownTopicConverter.format(params[:data].to_s)}</div>"
        @success = true
      end
    rescue => e
      logger.info [e, e.backtrace].flatten.join("\n")
    end

    respond_to do |format|
      format.json { render :json => {:data => @data, :status => !!@success} }
    end
  end

end
