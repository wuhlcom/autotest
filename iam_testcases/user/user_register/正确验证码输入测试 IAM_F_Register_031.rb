#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_031", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_num     = "15814236543"
        @tc_phone_pwd     = "123456"
        @tc_register_type = "phone"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入手机号码获取验证码；") {
        }

        operate("3、使用该手机号码进行注册，输入正确验证码；") {
            re   = @iam_obj.request_mobile_code(@tc_phone_num) #请求验证码
            code = re["code"]
            refute(code.nil?, "获取验证码失败")

            @rs = @iam_obj.register_user(@tc_phone_num, @tc_phone_pwd, @tc_register_type, code)
            assert_equal(1, @rs["result"], "使用正确的验证码注册用户失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num, @tc_phone_pwd)
            end
        }
    end

}
