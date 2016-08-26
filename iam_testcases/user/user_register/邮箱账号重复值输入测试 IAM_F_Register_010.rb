#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_010", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_user_name_1   = "liluping@zhilutec.com"
        @tc_user_pwd      = "123123"
        @tc_err_code      = "5006"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、使用邮箱注册用户；") {
            @rs1 = @iam_obj.register_emailusr(@tc_user_name_1, @tc_user_pwd, 1)
            assert_equal(1, @rs1["result"], "使用正确字符注册时，注册失败")
        }

        operate("3、再次注册一个用户，邮箱还使用步骤2的邮箱") {
            @rs2 = @iam_obj.register_emailusr(@tc_user_name_1, @tc_user_pwd, 1)
            assert_equal(@tc_err_code, @rs2["err_code"], "使用相同字符注册时，注册成功或者错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs1["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_1, @tc_user_pwd)
            end
        }
    end

}
