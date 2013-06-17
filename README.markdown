Rails 迷你问答论坛插件
==================================================================

### 使用
1.   添加qa-rails数据库表，bundle exec rake db:migrate
2.   在view里引用论坛插件，示例:

```ruby
qa_setup "#content .SectionBox .SectionList .forum",
         @current_lesson.id,
         :jsfun_user_avatar_url => "eoe.jsfun_user_avatar_url",
         :jsfun_user_info => "function() { return {uid:eoe.uid, uname:eoe.uname}; }",
         :empty_topics_text => 'Hey, 还没有问题，如果你有和本课相关但还不明白的问题，请在这里提问　:)',
         :notice_div => '$(".SectionBox[anchor=qa] .SectionHead .hasNew")'
```

### 其他论坛参考
*   https://github.com/radar/forem
*   https://github.com/discourse/discourse vendor下的gems值得一看

### License
MIT
