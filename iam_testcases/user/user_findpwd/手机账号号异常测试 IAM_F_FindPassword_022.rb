#
# description:
# author:liiluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_022", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_mod_num1 = "1382365236中"
        @tc_mod_num2 = "1382365test"
        @tc_mod_num3 = "138~!@#$%^&"
        @tc_mod_num4 = "138１２３４５６12"
        @tc_err_code = "5002"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入手机号带有中文、字母或者全角格式数字；") {
            p "手机号输入带中文汉字".encode("GBK")
            @rs1 = @iam_obj.request_mobile_code(@tc_mod_num1)
            assert_equal(@tc_err_code, @rs1["err_code"], "手机号输入带中文汉字时获取验证码成功，或者获取失败但是返回的错误码不正确")
            p "手机号输入带英文字母".encode("GBK")
            @rs1 = @iam_obj.request_mobile_code(@tc_mod_num2)
            assert_equal(@tc_err_code, @rs1["err_code"], "手机号输入带英文字母时获取验证码成功，或者获取失败但是返回的错误码不正确")
            p "手机号输入带特殊字符".encode("GBK")
            @rs1 = @iam_obj.request_mobile_code(@tc_mod_num3)
            assert_equal(@tc_err_code, @rs1["err_code"], "手机号输入带特殊字符时获取验证码成功，或者获取失败但是返回的错误码不正确")
            p "手机号输入带全角格式的数字".encode("GBK")
            @rs1 = @iam_obj.request_mobile_code(@tc_mod_num4)
            assert_equal(@tc_err_code, @rs1["err_code"], "手机号输入带全角格式的数字时获取验证码成功，或者获取失败但是返回的错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
