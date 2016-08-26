#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_009", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_usr_email = "zh ilu@zhilutec.com"
        @tc_err_code  = "5001"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入邮箱中间带有空格；") {
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email)
            assert_equal(@tc_err_code, rs["err_code"], "输入邮箱中间带有空格的邮箱账号找回密码成功或者找回失败但是错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
