# encoding: UTF-8

class CreateQa < ActiveRecord::Migration
  def up
    create_table :qa_topics, :options => 'ENGINE=Innodb DEFAULT CHARSET=utf8', :comment => "问答 主题" do |t|
      t.integer    :category_id, :comment => "分类ID", :default => 0
      t.integer    :uid, :comment => "作者ID", :default => 0
      t.string     :uname, :comment => "作者名字"
      t.string     :title, :comment => "主题的标题"
      t.text       :content, :comment => "主题的内容"
      t.integer    :replies_count, :comment => "回复数", :default => 0
      t.integer    :view_count, :comment => "阅读数", :default => 0
      t.boolean    :is_delete, :comment => "是否删除", :default => false
      t.boolean    :is_resolved, :comment => "是否解决", :default => false
      t.timestamps
    end
    add_index :qa_topics, [:is_delete, :category_id, :updated_at]

    create_table :qa_replies, :options => 'ENGINE=Innodb DEFAULT CHARSET=utf8', :comment => "问答 回复" do |t|
      t.integer    :topic_id, :comment => "主题 外键", :default => 0
      t.integer    :uid, :comment => "作者ID", :default => 0
      t.string     :uname, :comment => "作者名字"
      t.text       :content, :comment => "回复 内容"
      t.boolean    :is_delete, :comment => "是否删除", :default => false
      t.timestamps
    end
    add_index :qa_replies, [:is_delete, :topic_id, :created_at]

  end

  def down
  end

end
