#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_007", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_usr_email1 = "zhilu知路@zhilutec.com"
        @tc_usr_email2 = "zhilu~#$%@zhilutec.com"
        @tc_usr_email3 = "ＺＨＩＬＵ@zhilutec.com"
        @tc_err_code   = "5001"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、邮箱异常输入；") {
            p "邮箱输入框中输入带中文汉字的字符".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email1)
            assert_equal(@tc_err_code, rs["err_code"], "输入带中文汉字的字符的邮箱账号找回密码成功或者找回失败但是错误码不正确")
            p "邮箱输入框中输入带非下划线特殊字符的字符".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email2)
            assert_equal(@tc_err_code, rs["err_code"], "输入框中输入带非下划线特殊字符的字符的邮箱账号找回密码成功或者找回失败但是错误码不正确")
            p "邮箱输入框中输入带全角字符的字符".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email3)
            assert_equal(@tc_err_code, rs["err_code"], "输入框中输入带全角字符的字符的邮箱账号找回密码成功或者找回失败但是错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
