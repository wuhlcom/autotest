#
# description:
#  C013产品有问题，密码有特殊符号也能输入，且错误提示信息提示的可设置位数不一致
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
  attr = {"id" => "ZLBF_21.1.68", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_pw_null_err    = "用户名和密码不能为空"
    @tc_pw_content_err = "密码只能是数字和字母下划线"
    @tc_pw_null        = ""
    @tc_new_pw1        = "test 01"
    @tc_new_pw2        = "test$01"
    @tc_new_pw3        = "测试密码"
  end

  def process

    operate("1、登陆DUT，进入密码修改页面；") {
      rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
      assert(rs_login, "路由器登录失败！")

      @account_page = RouterPageObject::AccountPage.new(@browser)
      @account_page.open_account_page(@browser.url)
    }

    operate("2、密码为空，保持使用默认用户名，保存") {
      puts("修改密码为空".encode("GBK"))
      puts("修改用户名为：#{@ts_default_usr}".encode("GBK"))
      @account_page.input_usr(@ts_default_usr)
      @account_page.set_pw(@tc_pw_null) # 输入密码
      @account_page.save
      error_info =@account_page.error_msg
      puts("错误提示内容:#{error_info}".encode("GBK"))
      assert_equal(@tc_pw_null_err, error_info, "错误提示内容不正确")
    }

    operate("3、输入密码中含有空格,如\"test 01\",\"admin \"，保持使用默认用户名，保存") {
      puts("用户名为：#{@ts_default_usr}".encode("GBK"))
      puts("修改密码为:#{@tc_new_pw1}".encode("GBK"))
      puts("修改确认密码为:#{@tc_new_pw1}".encode("GBK"))
      @account_page.input_usr(@ts_default_usr)
      @account_page.set_pw(@tc_new_pw1) # 输入密码
      @account_page.save
      error_info =@account_page.error_msg
      puts("错误提示内容:#{error_info}".encode("GBK"))
      assert_equal(@tc_pw_content_err, error_info, "错误提示内容不正确")
    }

    operate("4、输入密码中含有特殊字符,如\"test$01\",\"admin+\",\"t**ab\"等总共32个特殊字符，保持使用默认用户名，保存") {
      puts("用户名为：#{@ts_default_usr}".encode("GBK"))
      puts("修改密码为:#{@tc_new_pw2}".encode("GBK"))
      puts("修改确认密码为:#{@tc_new_pw2}".encode("GBK"))
      @account_page.input_usr(@ts_default_usr)
      @account_page.set_pw(@tc_new_pw2) # 输入密码
      @account_page.save
      error_info =@account_page.error_msg
      puts("错误提示内容:#{error_info}".encode("GBK"))
      assert_equal(@tc_pw_content_err, error_info, "错误提示内容不正确")
    }

    operate("5、输入密码中含有中文,如\"测试密码\"，保持使用默认用户名，保存") {
      puts("用户名为：#{@ts_default_usr}".encode("GBK"))
      puts("修改密码为：#{@tc_new_pw3}".encode("GBK"))
      puts("修改确认密码为:#{@tc_new_pw3}".encode("GBK"))
      @account_page.input_usr(@ts_default_usr)
      @account_page.set_pw(@tc_new_pw3) # 输入密码
      @account_page.save
      error_info =@account_page.error_msg
      puts("错误提示内容:#{error_info}".encode("GBK"))
      assert_equal(@tc_pw_content_err, error_info, "错误提示内容不正确")
    }

  end

  def clearup

    operate("1 恢复默认账户") {
      @account_page = RouterPageObject::AccountPage.new(@browser)
      rs            = @account_page.login_with_exists(@browser.url)
      if rs #如果当前是登录界面，则先登录
        passwords =[@tc_new_pw1, @tc_new_pw2, @tc_new_pw3]
        flag      = false
        passwords.each do |pw|
          @account_page.login_with(@ts_default_usr, pw, @browser.url) #新帐户登录
          lan = @account_page.lan?
          if lan
            puts "修改为默认账户!".to_gbk
            @account_page.modify_account(@browser.url, @ts_default_usr, @ts_default_pw) #新账户登录成功则修改账户为默认
            flag = true
            break
          end
        end

        unless flag
          @account_page.login_with(@ts_default_usr, @ts_default_pw, @browser.url) #新帐户登录失败，则尝试使用旧账户登录
          lan = @account_page.lan?
          if lan
            puts "当前账户已经是默认账户!".to_gbk
          else
            puts "账户异常!".to_gbk
          end
        end
      else #如果当前页面不是登录页面，则说已经登录,就直接恢复为默认账户
        puts "直接恢复为默认账户!".to_gbk
        @account_page.modify_account(@browser.url, @ts_default_usr, @ts_default_pw)
      end
    }
  end

}
