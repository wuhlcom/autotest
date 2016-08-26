#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_028", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_app_name1        = "星期六"
    @tc_app_redirect_url = 'http://www.jd.com/?cu=true&utm_source=baidu-pinzhuan&utm_medium=cpc&utm_campaign=t_288551095_baidupinzhuan&utm_term=0f3d30c8dba7'
    @tc_args1            ={"name"         => @tc_app_name1,
                           "provider"     => "autotest",
                           "redirect_uri" => @tc_app_redirect_url,
                           "comments"     => "autotest"}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理员token值；") {
    }

    operate("3、创建应用，redirect_uri输入范围内；") {
      puts "回调地址长度为#{@tc_app_redirect_url.size}".to_gbk
      rs_app = @iam_obj.mana_create_app(@tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
