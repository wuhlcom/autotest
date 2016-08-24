#
# description:
#  C013产品有问题，密码有特殊符号也能输入，且错误提示信息提示的可设置位数不一致
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
  attr = {"id" => "ZLBF_F_System_6.7", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_login_error  = "用户名和密码不能为空"
    @tc_login_error2 = "用户名或密码错误"
    @tc_error_usr    = "mytest32"
  end

  def process

    operate("1、输入路由器的管理URL或域名；") {
      result = ping_recover(@ts_default_ip)
      assert(result, "路由器无法ping通")
    }

    operate("2、输入用户名为空，密码为正确密码，点击登录") {
      @login_page = RouterPageObject::LoginPage.new(@browser)
      @login_page.login_with("", @ts_default_pw, @ts_default_ip)
      error_msg = @login_page.main_error
      puts("ERROR TIP:#{error_msg}".encode("GBK"))
      assert_equal(error_msg, @tc_login_error, "未输入用户名也能登录")
    }

    operate("3、输入非空非法的用户名，密码为正确密码，点击登录") {
      @login_page = RouterPageObject::LoginPage.new(@browser)
      @login_page.login_with(@tc_error_usr, @ts_default_pw, @ts_default_ip)
      error_msg = @login_page.main_error
      puts("ERROR TIP:#{error_msg}".encode("GBK"))
      assert_equal(error_msg, @tc_login_error2, "输入错误用户名也能登录")
    }

  end

  def clearup

  end

}
