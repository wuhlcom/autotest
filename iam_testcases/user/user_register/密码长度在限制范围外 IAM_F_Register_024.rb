#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_024", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_num1 = "15814037407"
        @tc_phone_num2 = "15814037408"
        @tc_phone_pwd1 = "aa123"
        @tc_phone_pwd2 = "aa12347890aa12347890aa12347890123"
        @tc_err_code   = "5005"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入手机号码获取验证码；") {

        }

        operate("3、使用该手机号码进行注册，密码长度在范围外；") {
            p "密码输入框中输入5个字符".encode("GBK")
            @rs1 = @iam_obj.register_phoneusr(@tc_phone_num1, @tc_phone_pwd1)
            assert_equal(@tc_err_code, @rs1["err_code"], "密码为5个字符时注册成功或者注册失败但错误码不正确")

            p "密码输入框中输入33个字符".encode("GBK")
            @rs2 = @iam_obj.register_phoneusr(@tc_phone_num2, @tc_phone_pwd2)
            assert_equal(@tc_err_code, @rs2["err_code"], "密码为33个字符时注册成功或者注册失败但错误码不正确")

        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs1["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num1, @tc_phone_pwd1)
            end
            if @rs2["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num2, @tc_phone_pwd2)
            end
        }
    end

}
