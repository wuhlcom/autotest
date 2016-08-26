#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_010", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_usr_email1 = "ZHILU@ZHILUTEC.COM"
        @tc_usr_email2 = "zhilu@zhilutec.com"
        @tc_usr_email3 = "ZhiLu@zHilutec.cOm"
        @tc_err_code   = "11004"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入邮箱含有大写字母；") {
            p "输入框中输入字母全部大写的字符".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email1)
            assert_equal(@tc_err_code, rs["err_code"], "字母全部大写的字符的邮箱账号找回密码成功或者找回失败但是错误码不正确")

            p "输入框中输入字母全部小写的字符".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email1)
            assert_equal(@tc_err_code, rs["err_code"], "字母全部小写的字符的邮箱账号找回密码成功或者找回失败但是错误码不正确")

            p "输入框中输入字母大小写混合的字符".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email1)
            assert_equal(@tc_err_code, rs["err_code"], "字母大小写混合的字符的邮箱账号找回密码成功或者找回失败但是错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
