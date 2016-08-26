#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_002", "level" => nil, "auto" => "n"}

    def prepare
        @tc_usr_name = "liluping@zhilutec.com"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入存在邮箱找回密码；") {
            rs = @iam_obj.find_pwd_for_email(@tc_usr_name)
            assert_equal(1, rs["result"], "邮件找回密码发送失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
