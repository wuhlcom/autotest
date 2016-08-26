#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_030", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_mobile_phone  = "15815642765"
        @tc_telecom_phone = "18015642765"
        @tc_unicom_phone  = "18615642765"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、分别使用联通、电信、移动手机号码进行验证码获取测试；") {
            p "使用移动号码".encode("GBK")
            rs = @iam_obj.request_mobile_code(@tc_mobile_phone)
            assert(rs["mobile"] == @tc_mobile_phone && !rs["code"].nil?, "移动号码获取验证码失败")
            p "使用电信号码".encode("GBK")
            rs = @iam_obj.request_mobile_code(@tc_telecom_phone)
            assert(rs["mobile"] == @tc_telecom_phone && !rs["code"].nil?, "移动号码获取验证码失败")
            p "使用联通号码".encode("GBK")
            rs = @iam_obj.request_mobile_code(@tc_unicom_phone)
            assert(rs["mobile"] == @tc_unicom_phone && !rs["code"].nil?, "移动号码获取验证码失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
