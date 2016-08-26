#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_043", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_provider  = "zhilutec"
    @tc_provider2 = "jidujiao"
    @tc_comments  = "autotest"
    @tc_app_name1 = "活佛济公"
    @tc_app_name2 = "洽洽瓜子"
    @tc_args1     ={name: @tc_app_name1, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args2     ={name: @tc_app_name2, provider: @tc_provider2, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args3     ={name: @tc_app_name2, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理员token值；") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("3、获取修改应用的应用ID号;") {
      tip = "创建的应用名'#{@tc_app_name1}',应用提供方'#{@tc_provider}'"
      puts "#{tip}".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")

      tip = "创建的应用名'#{@tc_app_name2}',应用提供方'#{@tc_provider2}'"
      puts "#{tip}".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args2)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")
    }

    operate("4、修改provider值为已存在名称；") {
      tip = "应用'#{@tc_app_name2}'提供方由'#{@tc_provider2}'改为#{@tc_provider}"
      puts "#{tip}".to_gbk
     p rs_app= @iam_obj.mod_app(@tc_app_name2, @token, @admin_id, @tc_args3)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_app_name1)
      @iam_obj.mana_del_app(@tc_app_name2)
    }
  end

}
