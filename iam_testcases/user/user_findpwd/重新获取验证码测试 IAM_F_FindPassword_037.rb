#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_037", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_err_code  = "11002"
        @tc_wait_time = 125 #有延迟，增加5s
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "用户#{@ts_phone_usr}注册失败")
        }

        operate("2、获取手机验证码；") {
            re = @iam_obj.request_mobile_code(@ts_phone_usr) #请求验证码
            @code1 = re["code"]
            refute(@code1.nil?, "获取验证码失败")
        }

        operate("3、2分钟以后再次获取验证码；") {
            sleep @tc_wait_time
            re     = @iam_obj.request_mobile_code(@ts_phone_usr) #请求验证码
            @code2 = re["code"]
            refute(@code2.nil?, "获取验证码失败")
        }

        operate("4、使用第一次的验证码进行密码找回；") {
            rs = @iam_obj.usr_modpw_mobile_bycode(@ts_phone_usr, @ts_usr_pw, @code1)
            assert_equal(@tc_err_code, rs["err_code"], "2分钟后使用验证码找回密码成功，或者找回失败但是返回的错误码不正确")
        }

        operate("5、使用第二的验证吗进行密码找回；") {
            @rs = @iam_obj.usr_modpw_mobile_bycode(@ts_phone_usr, @ts_usr_pw, @code2)
            assert_equal(@ts_add_rs, @rs["result"], "2分钟后使用第二个验证码找回密码失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
        }
    end

}
