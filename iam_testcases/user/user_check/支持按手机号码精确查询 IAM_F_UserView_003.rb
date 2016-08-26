#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserView_003", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_number = "18814036534"
        @tc_phone_pw     = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            p "创建手机号用户".encode("GBK")
            @re = @iam_obj.register_phoneusr(@tc_phone_number, @tc_phone_pw)
            assert_equal(1, @re["result"], "注册手机用户失败")
        }

        operate("2、获取知路管理员token值；") {
            @res = @iam_obj.manager_login #管理员登录->得到uid和token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("3、按手机号码精确查询；") {
            args = {"type" => "account", "cond" => @tc_phone_number}
            rs   = @iam_obj.get_user_list(@admin_id, @admin_token, args)
            assert_equal("1", rs["totalRows"], "未查询到用户信息")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @re["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_number, @tc_phone_pw)
            end
        }
    end

}
