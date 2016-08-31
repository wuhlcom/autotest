#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserView_004", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_email_account = "nidayede@qq.com"
        @tc_email_pw      = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            p "创建邮箱用户".encode("GBK")
            @re = @iam_obj.register_emailusr(@tc_email_account, @tc_email_pw, 1)
            assert_equal(1, @re["result"], "注册邮箱用户失败")
        }

        operate("2、获取知路管理员token值；") {
            @res = @iam_obj.manager_login #管理员登录->得到uid和token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("3、按邮箱精确查询；") {
            args = {"type" => "account", "cond" => @tc_email_account}
            rs   = @iam_obj.get_user_list(@admin_id, @admin_token, args)
            assert_equal("1", rs["totalRows"], "未查询到用户信息")
            assert_equal(@tc_email_account, rs["users"][0]["account"], "未查询到#{@tc_email_account}的用户信息")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_delete_usr(@tc_email_account, @tc_email_pw)
        }
    end

}
