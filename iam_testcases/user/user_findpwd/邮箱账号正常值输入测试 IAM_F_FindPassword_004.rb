#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_004", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_usr_email1 = "abc@163.com"
        @tc_usr_email2 = "abc@qq.com"
        @tc_usr_email3 = "abc@yahoo.com"
        @tc_usr_email4 = "abc@gmail.com"
        @tc_usr_email5 = "abc@hotmail.com"
        @tc_usr_email6 = "zhilukeji1zhilukeji@zhilutec.com"
        @tc_usr_email7 = "zhilu123_123@zhilutec.com"
        @tc_err_code   = "11004"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入一个邮箱账号；") {
            p "输入非注册的163邮箱账号".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email1)
            assert_equal(@tc_err_code, rs["err_code"], "非注册的163邮箱账号找回密码成功或者找回失败但是错误码不正确")
            p "输入非注册的qq邮箱账号".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email2)
            assert_equal(@tc_err_code, rs["err_code"], "非注册的qq邮箱账号找回密码成功或者找回失败但是错误码不正确")
            p "输入非注册的yahoo邮箱账号".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email3)
            assert_equal(@tc_err_code, rs["err_code"], "非注册的yahoo邮箱账号找回密码成功或者找回失败但是错误码不正确")
            p "输入非注册的gamil邮箱账号".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email4)
            assert_equal(@tc_err_code, rs["err_code"], "非注册的gmail邮箱账号找回密码成功或者找回失败但是错误码不正确")
            p "输入非注册的hotmail邮箱账号".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email5)
            assert_equal(@tc_err_code, rs["err_code"], "非注册的hotmail邮箱账号找回密码成功或者找回失败但是错误码不正确")
            p "输入非注册的32位字符长度的邮箱账号".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email6)
            assert_equal(@tc_err_code, rs["err_code"], "非注册的32位字符长度的邮箱账号找回密码成功或者找回失败但是错误码不正确")
            p "输入非注册的带下划线的邮箱账号".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email7)
            assert_equal(@tc_err_code, rs["err_code"], "非注册的带下划线的邮箱账号找回密码成功或者找回失败但是错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
