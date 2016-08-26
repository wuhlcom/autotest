#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_027", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_app_name1        = "星期五"
    @tc_app_redirect_url = ""
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

    operate("3、创建应用，redirect_uri输入为空；") {
      tip    = "回调地址为空"
      rs_app = @iam_obj.mana_create_app(@tc_args1)
      puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_appnulurl_msg, rs_app["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_appnulurl_code, rs_app["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_appnulurl_desc, rs_app["err_desc"], "#{tip}返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {

    }
  end

}
