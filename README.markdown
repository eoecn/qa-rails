qa-rails
==================================================================
Rails Engine. a mini forum provided by only a simple helper, written in Backbones.js.

Usage
------------------------------------------------------------------
1.   Ad qa-rails tables，bundle exec rake db:migrate
2.   config it in view:

```ruby
qa_setup "#content .SectionBox .SectionList .forum",
         @current_lesson.id,
         :jsfun_user_avatar_url => "eoe.jsfun_user_avatar_url",
         :jsfun_user_info => "function() { return {uid:eoe.uid, uname:eoe.uname}; }",
         :empty_topics_text => 'Hey, 还没有问题，如果你有和本课相关但还不明白的问题，请在这里提问　:)',
         :notice_div => '$(".SectionBox[anchor=qa] .SectionHead .hasNew")'
```

Screenshots
------------------------------------------------------------------

[<img src="https://raw.github.com/eoecn/qa-rails/eoecn/screenshots/qa_list.png">](index)
[<img src="https://raw.github.com/eoecn/qa-rails/eoecn/screenshots/qa_show.png">](show)


Other forums written in Ruby and Javascript
------------------------------------------------------------------
*   https://github.com/radar/forem
*   https://github.com/discourse/discourse see /vendor/gems

Contributors
------------------------------------------------------------------
*   产品: @iceskysl
*   rails, javascript: @mvj3
*   css: @xiang97

License
------------------------------------------------------------------
MIT
