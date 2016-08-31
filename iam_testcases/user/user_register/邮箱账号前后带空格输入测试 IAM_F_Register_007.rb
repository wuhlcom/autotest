#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_007", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_user_name_1   = " zhilu123@qq.com"
        @tc_user_name_2   = "zhilutest123@qq.com "
        @tc_user_pwd      = "123123"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、注册邮箱前后带有空格；") {
            p "邮箱前面带有空格".encode("GBK")
            @rs1 = @iam_obj.register_emailusr(@tc_user_name_1, @tc_user_pwd, 1)
            assert_equal(1, @rs1["result"], "使用前面带有空格的邮箱注册时，注册失败")

            p "邮箱后面带有空格".encode("GBK")
            @rs2 = @iam_obj.register_emailusr(@tc_user_name_2, @tc_user_pwd, 1)
            assert_equal(1, @rs2["result"], "使用后面带有空格的邮箱注册时，注册失败")
        }

    end

    def clearup
        operate("1.恢复默认设置") {
                @iam_obj.usr_delete_usr(@tc_user_name_1.strip, @tc_user_pwd)
                @iam_obj.usr_delete_usr(@tc_user_name_2.strip, @tc_user_pwd)
        }
    end

}
