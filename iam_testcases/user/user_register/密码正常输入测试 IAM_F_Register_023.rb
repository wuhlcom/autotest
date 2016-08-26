#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_023", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_num1 = "15814037409"
        @tc_phone_num2 = "15814037407"
        @tc_phone_num3 = "15814037408"
        @tc_phone_pwd1 = "123123"
        @tc_phone_pwd2 = "aa12347890aa12347890aa1234789012"
        @tc_phone_pwd3 = "123__22Aa"
        @tc_err_code   = "5006"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入手机号码获取验证码；") {

        }

        operate("3、使用该手机号码进行注册，密码正常输入；") {
            p "密码输入框输入6个字符".encode("GBK")
            @rs1 = @iam_obj.register_phoneusr(@tc_phone_num1, @tc_phone_pwd1)
            assert_equal(1, @rs1["result"], "使用手机号注册用户失败")

            p "密码输入框中输入32个字符，带数字和字母".encode("GBK")
            @rs2 = @iam_obj.register_phoneusr(@tc_phone_num2, @tc_phone_pwd2)
            assert_equal(1, @rs2["result"], "使用手机号注册用户失败")

            p "密码输入框中输入带下划线字符".encode("GBK")
            @rs3 = @iam_obj.register_phoneusr(@tc_phone_num3, @tc_phone_pwd3)
            assert_equal(1, @rs3["result"], "使用手机号注册用户失败")
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
            if @rs3["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num3, @tc_phone_pwd3)
            end
        }
    end

}
