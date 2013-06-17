$(document).ready(function() {
  if (!$.fn.autosize) { console.log("warning: please use git://github.com/jackmoore/autosize.git to auto resize textarea"); $.fn.autosize = function() {}; }
  if (!$.fn.timeago) { console.log("warning: please use git://github.com/ashchan/smart-time-ago.git to compute time ago"); $.fn.timeago = function() {}; }

  // textarea 自适应高度
  var autosize = function() {
    setTimeout(function() {
      $("#content .forum textarea").autosize();
    }, 5000);
  };

  var scroll_to_div = function(_f) {
    // 用dom高度做动态计算
    var dom = $(QARails.domid).closest(".SectionList");
    var _top = dom.offset().top - 50;
    var _micro_seconds = dom.height() - 500;
    // 自动滚动到论坛顶部，以防止帖子超过一屏
    $("html, body").animate({ scrollTop: _top}, _micro_seconds);
    autosize();
  };
  var is_first_time_load_qa = true;

  // 设定 检查新内容的时间相关
  var now_int         = function() {
    return Math.round(new Date().getTime() / 1000);
  };
  var last_checked_at = now_int();

  // 论坛框架视图
  var QARootView = Backbone.View.extend({
    events: {
      "click .convert_tags span":     "edit_or_preview",
      "click .markdownBox a.reply":   "comment",
      "click .markdownBox a.ask":     "ask",
      "click .pagination span":       "ajax_paginate"
    },
    // 编辑或预览
    edit_or_preview: function(event) {
      event.preventDefault();
      if (!this.process_data(event)) { return false; }
      var dom = $(event.target);
      // 不能重复点击
      if (dom.hasClass('on')) { return false; }

      // 引用相对的输入框
      var textarea_dom = dom.closest(".convert_tags").siblings(".textareaBox");

      // 切换显示
      textarea_dom.find(".preview_box, .textarea_text").toggleClass('hide');
      this.$el.find(".convert_tags span").toggleClass('on');
      var that = this;

      // 判断是预览
      if (dom.hasClass('preview_button')) {
        // 传输数据到markdown渲染接口
        var _data = {data: this.content};
        $.post("/qa/markdown", _data, function(opts) {
          console.log(opts);
          // 渲染结果
          textarea_dom.find('.preview_content').html(opts.data);
        });
      }
    },
    btn_event: undefined,
    current_textarea_dom: undefined,
    markdown_editor_type: undefined,
    content: undefined,
    title: undefined,
    last_ask_title: undefined,
    last_comment_content: undefined,
    process_data: function(event) {
      this.btn_event             = event;
      var dom                    = $(this.btn_event.target).closest(".markdownBox").children(".convert_tags").siblings(".textareaBox");
      this.markdown_editor_type  = dom.find('.btn').attr('type');
      this.current_textarea_dom  = dom.find('textarea');
      var v                      = this.current_textarea_dom.val().split("\n");

      // remove blank line at the beign and the end
      var _length_pre, _length;
      while (_length_pre != v.length) {
        _length_pre = v.length;
        if (_.isEmpty(v[0])) { v.shift(); }
        if (_.isEmpty(v[v.length-1])) { v.pop(); }
      }

      switch(this.markdown_editor_type) {
        case 'ask':
          this.content = v.slice(1, v.length).join("\n");
          this.title   = v[0];
          dom.find('.preview_title').html(this.title);
          if (($.trim(this.title).length === 0) || ($.trim(this.content).length === 0)) {
            alert("至少包含标题和内容的两行内容！");
            return false;
          }
          break;
        case 'reply':
          this.content = v.join("\n");
          if ($.trim(this.content).length === 0) {
            alert("回复内容不能为空！");
            return false;
          }
          break;
      }

      return true;
    },
    ask: function(event) {
      if (!this.process_data(event)) { return false; }

      // no dup ask
      if (QARootView.last_ask_title === this.title) { alert("不能重复提问！"); return false; }
      QARootView.last_ask_title = this.title;

      var data = $.extend(QARails.default_ajax_data, {title: this.title, content: this.content});
      var that = this;
      $.post("/qa/topics.json", data).done(function(data) {
        QARootView.render();
      });

    },
    comment: function(event) {
      if (!this.process_data(event)) { return false; }
      // no dup ask
      if (QARootView.last_comment_content === this.content) { alert("不能重复回复！"); return false; }
      QARootView.last_comment_content = this.content;

      var topic_id = $(event.target).closest('.show').attr('topic_id');
      var data = $.extend(QARails.default_ajax_data, {topic_id: topic_id, content: this.content});
      $.ajax({
        url: "/qa/topics/" + topic_id + "/replies.json",
        type: "POST",
        data: data
      }).done(function(data) {
        QAShowView.render(data);
      });
    },
    // ajax分页
    ajax_paginate: function(event) {
      var dom = $(event.target);
      if (!dom.is('a')) { dom = dom.find('a'); }
      var url = "/qa/topics.json?" + dom.attr('href').split('?')[1];

      $.getJSON(url).done(function(data) {
        QAListTopicView.render(data);
        scroll_to_div();
      });

      return false;
    },
    template: _.template($("#qa_list_template").html()),
    render: function() {
      this.$el.html(this.template());
      return this;
    }
  });
  /* 渲染列表视图 */
  QARootView.render = function(page) {
    page = page || QARails.kaminari_config.page;
    var url = "/qa/topics.json?category_id=" +QARails.category_id + "&page=" + page + "&per=" + QARails.kaminari_config.per;
    $.getJSON(url, function(data) {
      console.log("qa-rails", data);
      $(QARails.domid).html((new QARootView()).render().el);
      QAListTopicView.render(data);

      setTimeout(function() {
        $("#qa .loading").hide();
        $('#qa .topic_list').removeClass('hide');

        if (!is_first_time_load_qa) {
          scroll_to_div();
          is_first_time_load_qa = false;
        }
      }, 1000);

      // 重新更新时间点
      last_checked_at = now_int();
    });
  };

  /* 论坛主题列表渲染视图 */
  var QAListTopicView = Backbone.View.extend({
    events: {
      "click li": 'topic_show'
    },
    /* 点击显示主题详情 */
    topic_show: function(event) {
      var topic_id = $(event.target).closest('li').attr('topic_id');
      $.getJSON("/qa/topics/" + topic_id + ".json", function(data) {
       QAShowView.render(data).show();
       scroll_to_div();
      });
    },
    template: _.template($("#qa_list_topic_template").html()),
    initialize: function(opts) {
      this.topics = opts.topics;
      return this;
    },
    render: function() {
      this.$el.html(this.template());
      return this;
    }
  });
  QAListTopicView.render = function(data) {
    var list_topic_view = new QAListTopicView(data);
    $("#qa ul").html(list_topic_view.render().el);
    $('#qa ul .timeago').timeago();
    $('#qa #kaminari').html(data.paginate_html);
    return list_topic_view;
  };


  /* 论坛主题回复渲染视图 */
  var QAShowView = Backbone.View.extend({
    events: {
      "click .back_to_list"          : "back_to_list"
    },
    show: function() {
      $("#qa .topic_list, #qa .topic_show").toggleClass('hide');
    },
    back_to_list: function() {
      var page = parseInt($(QARails.domid).find('.pagination span.current').text(), 10);
      QARootView.render(page);
    },
    template: _.template($("#qa_show_template").html()),
    initialize: function(opts) {
      this.topic = opts.topic;
      this.replies = opts.replies;
      return this;
    },
    render: function() {
      this.$el.html(this.template());
      return this;
    }
  });
  QAShowView.render = function(data) {
    var show_view = new QAShowView(data);
    $("#qa .topic_show").html(show_view.render().el);
    $("#qa .topic_show .timeago").timeago();
    return show_view;
  };

  // 初始化
  QARootView.render();
  autosize();

  // 问答新内容的轮询检查
  // 流程: 1, 设当前次刷新topic list的时间为最后时间点，然后轮询检查该时间点到现在有无新内容。2, 如果有，更新内容后才又开始 1 步骤; 如果无，继续轮询。
  setTimeout(function() {
    var notice_div      = $(QARails.notice_div);
    if (!_.isEmpty(notice_div)) {
      // 点击加载新列表
      notice_div.click(function() {
        QARootView.render();
        notice_div.html("");
      });

      // 轮询检查
      setInterval(function() {
        var url = "/qa/topics/new_topics_count.json?category_id=" + QARails.category_id + '&time_begin=' + last_checked_at;
        $.getJSON(url, function(data) {
          if (data.new_topcis_count > 0) {
            notice_div.html("有" + data.new_topcis_count + "条新内容 点击查看");
          } else {
            notice_div.html("");
            console.log(url + " 没有新内容");
          }
        });
      }, 60*1000);
    }
  }, 60*1000);


});
