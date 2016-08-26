#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_006", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_user_name_1   = "zhilu@知路.com"
        @tc_user_name_2   = "zhilu~#$%@zhilutec.com"
        @tc_user_name_3   = "zhilu@ＺＨＩＬＵ.com"
        @tc_user_pwd      = "123123"
        @tc_register_type = "email"
        @tc_err_code      = "5003"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、使用异常格式的邮箱进行注册；") {
            p "输入带中文汉字的字符".encode("GBK")
            rs = @iam_obj.register_user(@tc_user_name_1, @tc_user_pwd, @tc_register_type)
            assert_equal(@tc_err_code, rs["err_code"], "使用异常格式的的邮箱注册成功或者注册失败错误码不正确")
            p "输入框中输入带非下划线特殊字符的字符".encode("GBK")
            rs = @iam_obj.register_user(@tc_user_name_2, @tc_user_pwd, @tc_register_type)
            assert_equal(@tc_err_code, rs["err_code"], "使用异常格式的的邮箱注册成功或者注册失败错误码不正确")
            p "输入框中输入带全角字符的字符".encode("GBK")
            rs = @iam_obj.register_user(@tc_user_name_3, @tc_user_pwd, @tc_register_type)
            assert_equal(@tc_err_code, rs["err_code"], "使用异常格式的的邮箱注册成功或者注册失败错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
