#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_065", "level" => "P3", "auto" => "n"}

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

        operate("3、按应用名称查询cond值为空;") {
            rs   = @iam_obj.get_app_list(@admin_token, @admin_id)
            args = {"type" => "name", "cond" => ""}
            res  = @iam_obj.get_app_list(@admin_token, @admin_id, args)
            assert_equal(rs["totalRows"], res["totalRows"], "按应用名称查询cond值为空时，未返回全部结果！")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
