#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_028", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_phone_num2 = "15814037409"
        @tc_phone_pwd2 = "123 456"
        @tc_err_code   = "5005"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入手机号码获取验证码；") {
        }

        operate("3、使用该手机号码进行注册，密码带有空格；") {
            p "密码中间有空格".encode("GBK")
            rs = @iam_obj.register_phoneusr(@tc_phone_num2, @tc_phone_pwd2)
            assert_equal(@tc_err_code, rs["err_code"], "密码中间有空格时注册成功或者注册失败但错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
