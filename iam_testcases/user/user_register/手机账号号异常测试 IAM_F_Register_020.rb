#
# description: url不支持，该脚本不开发
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_020", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_phone_num1 = "1382365236中"
        @tc_phone_num2 = "1382365test"
        @tc_phone_num3 = "1382365$"
        @tc_phone_num4 = "138１２３４５６12"
        @tc_phone_pwd  = "123123"
        @tc_err_code   = "5002"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入异常手机号码进行注册；") {
            p "手机号输入带中文汉字".encode("GBK")
            p rs = @iam_obj.request_mobile_code(@tc_phone_num1)
            # assert_equal(@tc_err_code, rs["err_code"], "使用手机号带中文汉字注册用户成功或者注册失败但错误码不正确")
            p "手机号输入带英文字母".encode("GBK")
            p rs = @iam_obj.request_mobile_code(@tc_phone_num2)
            # assert_equal(@tc_err_code, rs["err_code"], "使用手机号带英文字母注册用户成功或者注册失败但错误码不正确")
            p "手机号输入带特殊字符".encode("GBK")
            p rs = @iam_obj.request_mobile_code(@tc_phone_num3)
            # assert_equal(@tc_err_code, rs["err_code"], "使用手机号带特殊字符注册用户成功或者注册失败但错误码不正确")
            p "手机号输入带全角格式的数字".encode("GBK")
            p rs = @iam_obj.request_mobile_code(@tc_phone_num4)
            # assert_equal(@tc_err_code, rs["err_code"], "使用手机号带全角格式的数字注册用户成功或者注册失败但错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
