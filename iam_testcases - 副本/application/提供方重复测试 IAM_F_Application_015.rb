#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_015", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_app_name1 = "自动烧汤"
    @tc_app_name2 = "智能切菜"
    @tc_app_pro   = "饭团团"
    @tc_args1     ={"name"         => @tc_app_name1,
                    "provider"     => @tc_app_pro,
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_args2     ={"name"         => @tc_app_name2,
                    "provider"     => @tc_app_pro,
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

    operate("3、创建应用，provider输入知路公司；") {
      tip = "创建的应用名'#{@tc_app_name1}',应用提供方'#{@tc_app_pro}'"
      puts "#{tip}".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")
    }

    operate("4、再次创建应用，provider输入知路公司；") {
      tip = "创建的应用名'#{@tc_app_name2}',应用提供方'#{@tc_app_pro}'"
      puts "#{tip}".to_gbk
      rs_app = @iam_obj.create_apply(@admin_id, @token, @tc_args2)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "再新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "再新增一个应用失败!")
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_app_name1)
      @iam_obj.mana_del_app(@tc_app_name2)
    }
  end
}
