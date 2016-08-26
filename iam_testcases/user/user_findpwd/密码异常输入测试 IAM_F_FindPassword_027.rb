#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_027", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_phone_num     = "15814037401"
        @tc_phone_pw1     = "中国1234"
        @tc_phone_pw2     = "！@\#$*("
        @tc_phone_pw3     = "１２３４５６"
        @tc_phone_default = "123123"
        @tc_error_code    = "5005"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取手机验证码；") {
        }

        operate("3、修改密码为特使字符或中文；") {
            p "密码输入中文".encode("GBK")
            @rs1 = @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw1)
            assert_equal(@tc_error_code, @rs1["err_code"], "修改密码输入中文时成功")
            p "密码输入特殊字符".encode("GBK")
            @rs2 = @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw2)
            assert_equal(@tc_error_code, @rs2["err_code"], "修改密码输入特殊字符时成功")
            p "密码输入全角格式数字".encode("GBK")
            @rs3 = @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw3)
            assert_equal(@tc_error_code, @rs3["err_code"], "修改密码输入全角格式数字时成功")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs1["result"] == 1 || @rs2["result"] == 1 || @rs3["result"] == 1
                @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_default)
            end
        }
    end

}
