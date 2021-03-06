#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_009", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_app_name1 = "SameAPP"
    @tc_args1     ={"name"         => @tc_app_name1,
                    "provider"     => "autotest",
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_args2     ={"name"         => @tc_app_name1,
                    "provider"     => "autotest2",
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest2"}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理员token值；") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("3、创建应用，其中名称#{@tc_app_name1}；") {
      tip = "创建的应用名#{@tc_app_name1}"
      puts "#{tip}".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")
    }

    operate("4、再次创建应用，名称{@tc_app_name1}；") {
      tip = "重复创建的应用#{@tc_app_name1}"
      puts "#{tip}".to_gbk
      rs_app = @iam_obj.mana_create_app(@tc_args2)
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
    }
  end

}
