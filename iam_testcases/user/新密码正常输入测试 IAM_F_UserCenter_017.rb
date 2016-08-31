#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_017", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_usr   = "15856031512"
        @tc_usr_pw      = "123456"
        @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}
        @tc_newPwd1     = "123123"
        @tc_newPwd2     = "aa12347890aa12347890aa1234789012"
        @tc_newPwd3     = "123__22Aa"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")
        }

        operate("2、登录用户获取access_token值和uid号；") {
        }

        operate("3、修改密码为新密码；") {
            rs    = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
            token = rs["access_token"]
            uid   = rs["uid"]

            p "密码输入框输入6个字符".encode("GBK")
            @rs1 = @iam_obj.mofify_user_pwd(@tc_usr_pw, @tc_newPwd1, uid, token)
            assert_equal(1, @rs1["result"], "修改密码失败")
            p "密码输入框中输入32个字符".encode("GBK")
            @rs2 = @iam_obj.mofify_user_pwd(@tc_newPwd1, @tc_newPwd2, uid, token)
            assert_equal(1, @rs2["result"], "修改密码失败")
            p "密码输入框中输入带下划线字符".encode("GBK")
            @rs3 = @iam_obj.mofify_user_pwd(@tc_newPwd2, @tc_newPwd3, uid, token)
            assert_equal(1, @rs3["result"], "修改密码失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_newPwd3)
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_newPwd2)
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_newPwd1)
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
        }
    end

}
