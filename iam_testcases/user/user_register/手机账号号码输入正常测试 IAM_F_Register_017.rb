#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_017", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_num_telecom = ["13342567824", "15342567824", "18042567824", "18142567824", "18942567824", "17742567824"]
        @tc_phone_num_mobile  = ["13442567824", "13542567824", "13642567824", "13742567824", "13842567824", "13942567824", "15042567824",
                                 "15142567824", "15242567824", "15742567824", "15842567824", "15942567824", "18242567824", "18342567824",
                                 "18442567824", "18742567824", "18842567824", "14742567824", "17842567824"]
        @tc_phone_num_unicom  = ["13042567824", "13142567824", "13242567824", "15542567824", "15642567824", "18542567824", "18642567824", "14542567824", "17642567824"]
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取验证码；（测试使用不同手机段的号码）") {
            @tc_phone_num_mobile.each do |number|
                mobile_flag = false
                rs = @iam_obj.request_mobile_code(number)
                if rs["mobile"] == number && !rs["code"].nil?
                    mobile_flag = true
                end
                assert(mobile_flag, "使用移动号码#{number}注册失败")
            end
            @tc_phone_num_unicom.each do |number|
                unicom_flag = false
                rs = @iam_obj.request_mobile_code(number)
                if rs["mobile"] == number && !rs["code"].nil?
                    unicom_flag = true
                end
                assert(unicom_flag, "使用联通号码#{number}注册失败")
            end
            @tc_phone_num_telecom.each do |number|
                telecom_flag = false
                rs = @iam_obj.request_mobile_code(number)
                if rs["mobile"] == number && !rs["code"].nil?
                    telecom_flag = true
                end
                assert(telecom_flag, "使用电信号码#{number}注册失败")
            end
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
