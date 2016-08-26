#
# description: 注册用户
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_019", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_phone_num = ""
        @tc_err_code  = "9001"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、手机号码输入为空") {
            rs = @iam_obj.request_mobile_code(@tc_phone_num)
            assert_equal(@tc_err_code, rs["err_code"], "使用空手机号码注册用户成功或者注册失败但错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
