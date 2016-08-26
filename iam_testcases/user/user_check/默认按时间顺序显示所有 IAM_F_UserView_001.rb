#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserView_001", "level" => "P2", "auto" => "n"}

    def prepare

    end

    def process

        operate("1、ssh登录IAM服务器；") {
            @res = @iam_obj.manager_login #管理员登录->得到uid和token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
        }

        operate("2、获取知路管理员token值；") {
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("3、默认查询所有用户；") {
            rs = @iam_obj.get_user_list(@admin_id, @admin_token)
            refute(rs["users"].empty?, "未查询到用户信息")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
