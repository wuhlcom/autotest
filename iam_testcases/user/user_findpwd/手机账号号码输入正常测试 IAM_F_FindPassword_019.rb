#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_019", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_mod_number = "15812345678"
        @tc_pwd_old    = "123456"
        @tc_pwd_new    = "12345678"
        @tc_err_code   = "2002"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取手机验证码；") {
        }

        operate("3、找回密码；") {
            @rs = @iam_obj.usr_modpw_mobile(@tc_mod_number, @tc_pwd_new)
            assert_equal(@tc_err_code, @rs["err_code"], "输入11位未注册的手机号找回密码成功，或者找回失败但是返回的错误码不正确")

        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs["result"] == 1
                @iam_obj.usr_modpw_mobile(@tc_mod_number, @tc_pwd_old)
            end
        }
    end

}
