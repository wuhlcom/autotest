#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserView_010", "level" => "P2", "auto" => "n"}

    def prepare

    end

    def process

        operate("1、ssh登录IAM服务器；") {

        }

        operate("2、获取知路管理员token值；") {
            @res = @iam_obj.manager_login #管理员登录->得到uid和token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("3、获取所有用户列表；") {
            rs = @iam_obj.get_user_list(@admin_id, @admin_token)
            refute(rs["users"].empty?, "获取所有用户列表失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
