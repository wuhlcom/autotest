#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_005", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_app_name = "WWW1234567"*3+"888"
    @tc_args     ={"name"         => @tc_app_name,
                   "provider"     => "autotest",
                   "redirect_uri" => @ts_app_redirect_uri,
                   "comments"     => "autotest"}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理员token值；") {
    }

    operate("3、创建应用，其中名称输入33个字符；") {
      tip = "创建的应用名长度为#{@tc_app_name.size}"
      puts "#{tip}".to_gbk
      rs_app = @iam_obj.mana_create_app(@tc_args)
      puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_appformat_msg, rs_app["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_appformat_code, rs_app["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_appformat_desc, rs_app["err_desc"], "#{tip}返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_app_name)
    }
  end

}
