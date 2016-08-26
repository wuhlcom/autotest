#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_036", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_num = "15814037400"
        @tc_phone_pw  = "123123"
        @tc_err_code  = "11003"
        @tc_wait_time = 125 #有延迟，增加5s
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取手机验证码；") {
            re    = @iam_obj.request_mobile_code(@tc_phone_num) #请求验证码
            p @code = re["code"]
            refute(@code.nil?, "获取验证码失败")
        }

        operate("3、2分钟以后进行密码找回；") {
            sleep @tc_wait_time
            rs       = @iam_obj.usr_modpw_mobile_bycode(@tc_phone_num, @tc_phone_pw, @code)
            assert_equal(@tc_err_code, rs["err_code"], "2分钟后使用验证码找回密码成功，或者找回失败但是返回的错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
