#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_037", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_num        = "15814037401"
        @tc_phone_pw         = "123456"
        @tc_phone_pw_default = "123123"
        @tc_err_code         = "11002"
        @tc_wait_time        = 120
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取手机验证码；") {
            re = @iam_obj.request_mobile_code(@tc_phone_num) #请求验证码
            p @code1 = re["code"]
            refute(@code1.nil?, "获取验证码失败")
        }

        operate("3、2分钟以后再次获取验证码；") {
            sleep @tc_wait_time
            re     = @iam_obj.request_mobile_code(@tc_phone_num) #请求验证码
            @code2 = re["code"]
            refute(@code2.nil?, "获取验证码失败")
        }

        operate("4、使用第一次的验证码进行密码找回；") {
            p rs = @iam_obj.usr_modpw_mobile_bycode(@tc_phone_num, @tc_phone_pw, @code1)
            assert_equal(@tc_err_code, rs["err_code"], "2分钟后使用验证码找回密码成功，或者找回失败但是返回的错误码不正确")
        }

        operate("5、使用第二的验证吗进行密码找回；") {
            p @rs = @iam_obj.usr_modpw_mobile_bycode(@tc_phone_num, @tc_phone_pw, @code2)
            assert_equal(1, @rs["result"], "2分钟后使用第二个验证码找回密码失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw_default)
        }
    end

}
