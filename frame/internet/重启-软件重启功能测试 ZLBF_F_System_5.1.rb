#
#description:
# 用例太过复杂，整改用例后再实现
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.29", "level" => "P1", "auto" => "n"}

    def prepare

    end

    def process

        operate("1 在快捷操作页面重启路由器") {
            @main_page = RouterPageObject::MainPage.new(@browser)
            @main_page.reboot

            @login_page = RouterPageObject::LoginPage.new(@browser)
            rs          = @login_page.login_with_exists(@browser.url)
            assert rs, "重启路由器失败未跳转到登录页面!"
        }

        operate("2 使用高级设置界面的重启功能") {
            puts "新版本高级设置中已经取消重启功能！".encode("GBK")
        }
    end

    def clearup

    end

}
