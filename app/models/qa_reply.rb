# encoding: UTF-8

class QAReply < ActiveRecord::Base
  acts_as_paranoid :column => 'is_delete', :column_type => 'boolean'

  include QA_Rails::ContentMarkdownCache

end
