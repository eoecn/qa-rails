# encoding: UTF-8

class QATopic < ActiveRecord::Base
  acts_as_paranoid :column => 'is_delete', :column_type => 'boolean'
  attr_accessible(*self.column_names)

  has_many :replies, :class_name => QAReply, :foreign_key => :topic_id

  # TODO expire from list if reply is delete
  def last_reply reload = false
    _r = Rails.cache.fetch self.last_reply_cache_key do
      _last_reply.to_json
    end
    JSON.parse(_r)
  end
  def _last_reply
    self.replies.last || {}
  end

  def last_reply_cache_key; "qa:topic_#{self.id}:last_reply" end
  def t; self.created_at.strftime("%Y%m%d-%H%M%S") end

  include QA_Rails::ContentMarkdownCache
end
