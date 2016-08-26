#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_017", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_newPwd1 = "123456"
        @tc_newPwd2 = "aa12347890aa12347890aa1234789012"
        @tc_newPwd3 = "123__22Aa"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、登录用户获取access_token值和uid号；") {
        }

        operate("3、修改密码为新密码；") {
            p "密码输入框输入6个字符".encode("GBK")
            @rs1 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @ts_usr_pwd, @ts_usr_pwd, @tc_newPwd1)
            assert_equal(1, @rs1["result"], "修改密码失败")
            p "密码输入框中输入32个字符".encode("GBK")
            @rs2 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @tc_newPwd1, @tc_newPwd1, @tc_newPwd2)
            assert_equal(1, @rs2["result"], "修改密码失败")
            p "密码输入框中输入带下划线字符".encode("GBK")
            @rs3 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @tc_newPwd2, @tc_newPwd2, @tc_newPwd3)
            assert_equal(1, @rs3["result"], "修改密码失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs3["result"] == 1
                @iam_obj.usr_modify_pw_step(@ts_usr_name, @tc_newPwd3, @tc_newPwd3, @ts_usr_pwd)
            elsif @rs2["result"] == 1
                @iam_obj.usr_modify_pw_step(@ts_usr_name, @tc_newPwd2, @tc_newPwd2, @ts_usr_pwd)
            elsif @rs1["result"] == 1
                @iam_obj.usr_modify_pw_step(@ts_usr_name, @tc_newPwd1, @tc_newPwd1, @ts_usr_pwd)
            end
        }
    end

}
