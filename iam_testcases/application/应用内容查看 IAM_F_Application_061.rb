#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_061", "level" => "P2", "auto" => "n"}

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

        operate("3、获取应用列表;") {
            rs = @iam_obj.get_app_list(@admin_token, @admin_id)
            rs_app = rs["apps"][0]
            rs_flag = rs_app.has_key?("client_id") && rs_app.has_key?("client_secret") && rs_app.has_key?("name") && rs_app.has_key?("provider") && rs_app.has_key?("status")
            assert(rs_flag, "应用列表显示内容不正确！")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
