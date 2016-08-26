#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_018", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_num_12 = "158140374001"
        @tc_phone_num_10 = "1581403740"
        @tc_err_code     = "5002"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、手机号码长度大于11位或者小于11位；") {
            p "使用12位号码".encode("GBK")
            rs = @iam_obj.request_mobile_code(@tc_phone_num_12)
            assert_equal(@tc_err_code, rs["err_code"], "使用手机号码长度大于11位注册用户成功或者注册失败但错误码不正确")
            p "使用10位号码".encode("GBK")
            rs = @iam_obj.request_mobile_code(@tc_phone_num_10)
            assert_equal(@tc_err_code, rs["err_code"], "使用手机号码长度小于11位注册用户成功或者注册失败但错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
