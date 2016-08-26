#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_039", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_phone_num1 = "15814037401"
        @tc_phone_num2 = "15814037402"
        @tc_phone_pw   = "123456"
        @tc_err_code   = "11002"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、手机号A获取手机验证码；") {
            re = @iam_obj.request_mobile_code(@tc_phone_num1) #请求验证码
            @code1 = re["code"]
            refute(@code1.nil?, "获取验证码失败")
        }

        operate("3、手机号B修改密码，验证码输入手机号A的验证码；") {
            rs = @iam_obj.usr_modpw_mobile_bycode(@tc_phone_num2, @tc_phone_pw, @code1)
            assert_equal(@tc_err_code, rs["err_code"], "通过其他手机获取的验证码找回密码成功，或者找回失败但是返回的错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
