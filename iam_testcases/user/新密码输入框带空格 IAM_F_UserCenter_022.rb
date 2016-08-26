#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_022", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_newPwd1  = " 123456"
        @tc_newPwd2  = "123 456"
        @tc_newPwd3  = "123456 "
        @tc_err_code = "11007"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、登录用户获取access_token值和uid号；") {
        }

        operate("3、修改密码，新密码输入带有空格；") {
            @rs1 = {}
            @rs2 = {}
            @rs3 = {}
            @rs2 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @ts_usr_pwd, @ts_usr_pwd, @tc_newPwd2)
            assert_equal(@tc_err_code, @rs2["err_code"], "修改密码成功")
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
