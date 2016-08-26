#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_005", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_usr_email = "zhilukeji1zhilukeji1@zhilutec.com"
        @tc_err_code   = "11004"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入邮箱长度在范围外；") {
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email)
            assert_equal(@tc_err_code, rs["err_code"], "长度为33个祝福的邮箱账号找回密码成功或者找回失败但是错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
