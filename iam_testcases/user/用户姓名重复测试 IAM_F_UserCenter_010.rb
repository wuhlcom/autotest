#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_010", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_usr1     = "15814037401"
        @tc_usr1_pwd = "123123"
        @tc_usr2     = "nihaoma@qq.com"
        @tc_usr2_pwd = "123456"
        @tc_usr_name = "王小二"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            @rs1 = @iam_obj.register_phoneusr(@tc_usr1, @tc_usr1_pwd)
            assert_equal(1, @rs1["result"], "注册手机账户失败")

            @rs2 = @iam_obj.register_emailusr(@tc_usr2, @tc_usr2_pwd, "1")
            assert_equal(1, @rs2["result"], "注册邮箱账户失败")
        }

        operate("2、登录用户获取access_token值和uid号；") {
            rs      = @iam_obj.user_login(@tc_usr1, @tc_usr1_pwd)
            @uid1   = rs["uid"]
            @token1 = rs["access_token"]
        }

        operate("3、设置用户A姓名为王小二；") {
            args = {"name" => @tc_usr_name}
            rs   = @iam_obj.usr_modify(@uid1, @token1, args)
            assert_equal(1, rs["result"], "用户姓名更新资料失败")
        }

        operate("4、设置用户B姓名为王小二；") {
            rs      = @iam_obj.user_login(@tc_usr2, @tc_usr2_pwd)
            @uid2   = rs["uid"]
            @token2 = rs["access_token"]

            args = {"name" => @tc_usr_name}
            rs   = @iam_obj.usr_modify(@uid2, @token2, args)
            assert_equal(1, rs["result"], "用户姓名更新资料失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs1["result"] == 1
                @iam_obj.usr_delete_usr(@tc_usr1, @tc_usr1_pwd)
            end
            if @rs2["result"] == 1
                @iam_obj.usr_delete_usr(@tc_usr2, @tc_usr2_pwd)
            end
        }
    end

}
