# encoding: UTF-8

require 'markdown-ruby-china'

 
module QA_Rails
  module ContentMarkdownCache
    extend ActiveSupport::Concern
    def _content_markdown_cache
      seconds = Rails.env == 'development' ? 1.second : 5.minutes
      key     = "/json/#{self.class.table_name}/#{self.id}/_content_markdown_cache"
      Rails.cache.fetch(key, :expires_in => seconds) do
        c = MarkdownTopicConverter.format(self.content.to_s)
        puts self.content.inspect, " - "*8, c
        c
      end
    end
  end
end

# TODO load git://github.com/pragmaticly/smart-time-ago.git

module ApplicationHelper
  # Setup QA mini forum
  #
  # domid       - which dom you want to append
  # category_id - board_id
  #
  # options[:jsfun_user_avatar_url] => 
  # function(uid) { return "http://gravater.com/" + uid + ".png" };
  #
  def qa_setup domid, category_id = 1, options = {}
    @qa_options = options
    @qa_options[:domid] = domid
    @qa_options[:category_id] = category_id
    params[:category_id] = category_id

    raise "Your should setup jsfun_user_avatar_url" if not @qa_options[:jsfun_user_avatar_url]
    raise "Your should setup jsfun_user_info" if not @qa_options[:jsfun_user_info]

    render :partial => "qa/qa"
  end
end


require File.expand_path('../rails_engine.rb', __FILE__)
