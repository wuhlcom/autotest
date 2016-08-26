#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_021", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_mod_num  = ""
        @tc_err_code = "9001"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、手机号码输入为空；") {
            @rs1 = @iam_obj.request_mobile_code(@tc_mod_num)
            assert_equal(@tc_err_code, @rs1["err_code"], "手机号为空时获取验证码成功，或者获取失败但是返回的错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
