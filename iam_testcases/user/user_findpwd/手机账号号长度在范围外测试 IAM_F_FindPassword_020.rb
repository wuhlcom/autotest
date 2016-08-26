#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_020", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_mod_num1 = "138265454444"
        @tc_mod_num2 = "1382645656"
        @tc_err_code = "5002"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、手机号码输入大于11位或者小于11位；") {
            p "手机号输入大于11位号码".encode("GBK")
            @rs1 = @iam_obj.request_mobile_code(@tc_mod_num1)
            assert_equal(@tc_err_code, @rs1["err_code"], "输入大于11位的手机号获取验证码成功，或者获取失败但是返回的错误码不正确")

            p "手机号输入小于11位".encode("GBK")
            @rs2 = @iam_obj.request_mobile_code(@tc_mod_num2)
            assert_equal(@tc_err_code, @rs2["err_code"], "输入小于11位的手机号获取验证码成功，或者获取失败但是返回的错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
