#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_004", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_user_name_33      = "zhilukeji1zhilukejif@zhilutec.com"
        @tc_user_pwd          = "123123"
        @tc_register_type     = "email"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、使用邮箱注册用户，邮箱长度33字符；") {
            rs = @iam_obj.register_user(@tc_user_name_33, @tc_user_pwd, @tc_register_type)
            refute_equal(1, rs["result"], "使用长度超过33个字符的用户名注册邮箱成功")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
