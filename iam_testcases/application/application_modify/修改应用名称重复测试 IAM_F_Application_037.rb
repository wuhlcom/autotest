#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_037", "level" => "P2", "auto" => "n"}

  def prepare

    @tc_provider  = "zhilutec"
    @tc_comments  = "autotest"
    @tc_app_name1 = "山东苹果"
    @tc_args1     ={name: @tc_app_name1, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_app_name2 = "山东苹果2"
    @tc_args2     ={name: @tc_app_name2, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
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
      puts "创建应用名为'#{@tc_app_name1}'".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "创建应用名为'#{@tc_app_name1}'失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "创建应用名为'#{@tc_app_name1}'失败!")

      puts "创建应用名为'#{@tc_app_name2}'".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args2)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "创建应用名为'#{@tc_app_name2}'失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "创建应用名为'#{@tc_app_name2}'失败!")
    }

    operate("4、修改应用名称为已存在的名称；") {
      tip = "应用名由'#{@tc_app_name2}'======>修改为'#{@tc_app_name1}'"
      puts tip.to_gbk
      rs_app= @iam_obj.mod_app(@tc_app_name2, @token, @admin_id, @tc_args1)
      puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_appexists_msg, rs_app["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_appexists_code, rs_app["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_appexists_desc, rs_app["err_desc"], "#{tip}返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_app_name1)
      @iam_obj.mana_del_app(@tc_app_name2)
    }
  end

}
