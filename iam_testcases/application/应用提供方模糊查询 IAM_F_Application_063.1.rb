#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_063", "level" => "P2", "auto" => "n"}

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

        operate("3、按应用提供方模糊查询;") {
            args = {"type"=>"provider", "cond"=>@ts_app_provider_001}
            rs = @iam_obj.get_app_list_chinese(@admin_token, @admin_id, args)
            assert(rs["totalRows"] != "0", "按应用提供方模糊查询失败，未查询到数据！")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
