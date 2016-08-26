#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_020", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_app_name1    = "电源管理"
    @tc_app_pro      = "深圳知路IDC"
    @tc_app_comment1 = " PowerManager"
    @tc_args1        ={"name"         => @tc_app_name1,
                       "provider"     => @tc_app_pro,
                       "redirect_uri" => @ts_app_redirect_uri,
                       "comments"     => @tc_app_comment1}
    @tc_app_name2    = "温度控制"
    @tc_app_comment2 = "TemperatureControl "
    @tc_args2        ={"name"         => @tc_app_name2,
                       "provider"     => @tc_app_pro,
                       "redirect_uri" => @ts_app_redirect_uri,
                       "comments"     => @tc_app_comment2}
    @tc_app_name3    = "温度控制2"
    @tc_app_comment3 = "Humidity Control"
    @tc_args3        ={"name"         => @tc_app_name3,
                       "provider"     => @tc_app_pro,
                       "redirect_uri" => @ts_app_redirect_uri,
                       "comments"     => @tc_app_comment3}
    @tc_args         =[@tc_args1, @tc_args2, @tc_args3]
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理员token值；") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("3、创建应用，comments输入带空格；") {
      @tc_args.each do |args|
        tip = "创建应用名为'#{args["name"]}',简介为'#{args["comments"]}'"
        puts "#{tip}".to_gbk
        rs_app= @iam_obj.create_apply(@admin_id, @token, args)
        assert_equal(@ts_admin_log_rs, rs_app["result"], "#{tip}失败!")
        assert_equal(@ts_msg_ok, rs_app["msg"], "#{tip}失败!")
      end
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @tc_args.each do |args|
        puts "删除应用'#{args["name"]}'".to_gbk
        @iam_obj.mana_del_app(args["name"])
      end
    }
  end

}
