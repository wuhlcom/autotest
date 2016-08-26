#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_074", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_man_name="19943215321"
    end

    def process

        operate("1、SSH登录IAM系统；") {
        }

        operate("2、不存在手机号、获取手机验证码；") {
            rs = @iam_obj.request_mobile_code(@tc_man_name)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_pcode_msg, rs["err_msg"], "不存在手机号获取验证码返回错误消息不正确!")
            assert_equal(@ts_err_pcode_code, rs["err_code"], "不存在手机号获取验证码返回错误code不正确!")
            assert_equal(@ts_err_pcode_desc, rs["err_desc"], "不存在手机号获取验证码返回错误desc不正确!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
