#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_033", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_num1    = "15814236543"
        @tc_phone_num2    = "15814235682"
        @tc_phone_pwd     = "123456"
        @tc_register_type = "phone"
        @tc_err_code      = "11002"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入手机号码获取验证码；") {
            re    = @iam_obj.request_mobile_code(@tc_phone_num1) #请求验证码
            @code = re["code"]
            refute(@code.nil?, "获取验证码失败")
        }

        operate("3、使用该手机号码进行注册，输入该验证码；") {
            @rs1 = @iam_obj.register_user(@tc_phone_num1, @tc_phone_pwd, @tc_register_type, @code)
            assert_equal(1, @rs1["result"], "使用正确的验证码注册用户失败")
        }

        operate("4、使用另外一个手机，输入步骤2获取到的验证码进行注册；") {
            re   = @iam_obj.request_mobile_code(@tc_phone_num2) #请求验证码
            code = re["code"]
            refute(code.nil?, "获取验证码失败")

            @rs2 = @iam_obj.register_user(@tc_phone_num2, @tc_phone_pwd, @tc_register_type, @code)
            assert_equal(@tc_err_code, @rs2["err_code"], "使用错误的验证码注册用户成功")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs1["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num1, @tc_phone_pwd)
            end
            if @rs2["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num2, @tc_phone_pwd)
            end
        }
    end

}
