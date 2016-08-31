#
# description:
# author:lilupng
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_009", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_user_name_1 = "NIDAYE@SOHU.COM"
        @tc_user_name_2 = "nidaye@qq.com"
        @tc_user_name_3 = "nIdAYe@163.cOm"
        @tc_user_pwd    = "123123"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、注册邮箱账号含有大小写字母；") {
            p "输入字母全部大写的字符".encode("GBK")
            p @rs1 = @iam_obj.register_emailusr(@tc_user_name_1, @tc_user_pwd, 1)
            assert_equal(1, @rs1["result"], "使用字母全部大写的字符注册时，注册失败")

            p "输入字母全部小写的字符".encode("GBK")
            p @rs2 = @iam_obj.register_emailusr(@tc_user_name_2, @tc_user_pwd, 1)
            assert_equal(1, @rs2["result"], "使用字母全部小写的字符注册时，注册失败")

            p "输入字母大小写混合的字符".encode("GBK")
            p @rs3 = @iam_obj.register_emailusr(@tc_user_name_3, @tc_user_pwd, 1)
            assert_equal(1, @rs3["result"], "使用字母大小写混合的字符注册时，注册失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_delete_usr(@tc_user_name_1, @tc_user_pwd)
            @iam_obj.usr_delete_usr(@tc_user_name_2, @tc_user_pwd)
            @iam_obj.usr_delete_usr(@tc_user_name_3, @tc_user_pwd)
        }
    end

}
