#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_029", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_mobile_phone  = "15815642765"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、分别使用联通、电信、移动手机号码进行验证码获取测试；") {
            rs = ""
            n = 0
            Thread.new do
                p rs = @iam_obj.request_mobile_code(@tc_mobile_phone)
            end
            11.times do
                n += 1
                break if rs["mobile"] == @tc_mobile_phone && !rs["code"].nil?
                sleep 1
            end
            assert(n<=10, "10秒之内未收到验证码短信！")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
