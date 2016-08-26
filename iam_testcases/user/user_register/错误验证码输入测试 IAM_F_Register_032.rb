#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_032", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_phone_num     = "15814236543"
        @tc_phone_pwd     = "123456"
        @tc_register_type = "phone"
        @tc_err_code      = "11002"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入手机号码获取验证码；") {
        }

        operate("3、使用该手机号码进行注册，输入错误验证码；") {
            re   = @iam_obj.request_mobile_code(@tc_phone_num) #请求验证码
            code = re["code"]
            refute(code.nil?, "获取验证码失败")

            code = code+1
            rs   = @iam_obj.register_user(@tc_phone_num, @tc_phone_pwd, @tc_register_type, code)
            assert_equal(@tc_err_code, rs["err_code"], "使用错误的验证码注册用户成功")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
