#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserView_008", "level" => "P1", "auto" => "n"}

    def prepare

    end

    def process

        operate("1、ssh登录IAM服务器；") {
            @res = @iam_obj.manager_login #管理员登录->得到uid和token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("2、获取知路管理员token值；") {

        }

        operate("3、获取用户id；") {
            rs         = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @usr_token = rs["access_token"]
            @usr_id    = rs["uid"]
        }

        operate("4、查询某个用户详情") {
            rs = @iam_obj.get_user_details(@admin_id, @admin_token, @usr_id)
            assert_equal(@ts_usr_name, rs["account"], "查询用户详细信息失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
