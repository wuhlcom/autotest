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
        @tc_pw_length_err = "密码的长度必须在4到32个字符之间"
        @tc_new_pw1       = "012345678901234567890123456789012"
        @tc_new_pw2       = "usr"
    end

    def process

        operate("1、登陆DUT，进入密码修改页面；") {
            rs_login = login_recover(@browser, @ts_powerip, @ts_default_ip)
            assert(rs_login, "路由器登录失败！")

            @account_page = RouterPageObject::AccountPage.new(@browser)
            @account_page.open_account_page(@browser.url)
        }

        operate("2、输入33密码,如test_0123456789012345678901234567，保持使用默认用户名，保存并使用修改后的账户登录路由器") {
            puts("用户名为：#{@ts_default_usr}".encode("GBK"))
            puts("修改密码为#{@tc_new_pw1.size}字符".encode("GBK"))
            puts("修改密码为：#{@tc_new_pw1}".encode("GBK"))
            @account_page.input_usr(@ts_default_usr)
            @account_page.set_pw(@tc_new_pw1) # 输入密码
            @account_page.save
            error_info = @account_page.error_msg
            puts("错误提示内容:#{error_info}".encode("GBK"))
            assert_equal(@tc_pw_length_err, error_info, "错误提示内容不正确")
        }

        operate("3、输入3位密码,如usr，保持使用默认用户名，保存并使用修改后的账户登录路由器") {
            puts("用户名为：#{@ts_default_usr}".encode("GBK"))
            puts("修改密码为#{@tc_new_pw2.size}字符".encode("GBK"))
            puts("修改密码为：#{@tc_new_pw2}".encode("GBK"))
            @account_page.input_usr(@ts_default_usr)
            @account_page.set_pw(@tc_new_pw2) # 输入密码
            @account_page.save
            error_info = @account_page.error_msg
            puts("错误提示内容:#{error_info}".encode("GBK"))
            assert_equal(@tc_pw_length_err, error_info, "错误提示内容不正确")
        }

    end

    def clearup

        operate("1 恢复默认账户") {
            @account_page = RouterPageObject::AccountPage.new(@browser)
            rs            = @account_page.login_with_exists(@browser.url)
            if rs #如果当前是登录界面，则先登录
                passwords =[@tc_new_pw1, @tc_new_pw2]
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
