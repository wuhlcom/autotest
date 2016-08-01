#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_070", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_man_name = "18900001111"
        @tc_nickname = "phone_manager"
        @tc_passwd   = "123456_dddd"
    end

    def process

        operate("1、SSH登录IAM系统；") {
        }

        operate("2、获取手机验证码；") {
        }

        operate("3、输入新密码；") {
            rs = @iam_obj.mobile_manager_modpw(@tc_man_name, @tc_passwd, @tc_nickname)
            puts "RESULT:#{rs}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加修改手机账户超级管理员密码失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
        }
    end

}
