#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_025", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_phone_num = "15814037408"
        @tc_phone_pwd = ""
        @tc_err_code  = "5005"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入手机号码获取验证码；") {
        }

        operate("3、使用该手机号码进行注册，密码为空；") {
            rs = @iam_obj.register_phoneusr(@tc_phone_num, @tc_phone_pwd)
            assert_equal(@tc_err_code, rs["err_code"], "密码为空时注册成功或者注册失败但错误码不正确")

        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
