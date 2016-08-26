#
# description:
# author:lilupng
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_069", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_app_usr      = "autotest_new"
        @tc_app_provider = "autotest"
        @tc_app_red_uri  = "http://192.168.10.9"
        @tc_err_code     = "22015"
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

        operate("3、获取要删除应用ID号，其中该应用已绑定用户；") {
            p "创建一个新应用".encode("GBK")
            args = {"name"=>@tc_app_usr, "provider"=>@tc_app_provider, "redirect_uri"=>@tc_app_red_uri, "comments"=>""}
            rs   = @iam_obj.create_apply(@admin_id, @admin_token, args)
            assert_equal(1, rs["result"], "创建应用失败！")

            # 获取应用ID
            @client_id = @iam_obj.get_client_id(@tc_app_usr, @admin_token, @admin_id)
            # 应用绑定用户
            p "用户登录返回用户Id和Token".encode("GBK")
            rs = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @usr_id = rs["uid"]
            @usr_token = rs["access_token"]
            p "应用绑定用户".encode("GBK")
            data = "{\"client_id\":\"#{@client_id}\"}"
            rs_bind = @iam_obj.usr_binding_app(@usr_token, @usr_id, data)
            assert_equal(1, rs_bind["result"], "应用绑定用户失败！")
        }

        operate("4、删除该应用；") {
            rs_del = @iam_obj.del_apply(@tc_app_usr, @admin_token, @admin_id)
            assert_equal(@tc_err_code, rs_del["err_code"], "删除应用失败后返回的错误码不正确！")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            p "应用解绑用户".encode("GBK")
            data = "{\"client_id\":\"#{@client_id}\"}"
            @iam_obj.usr_unbinding_app(@usr_token, @usr_id, data)

            p "删除应用".encode("GBK")
            @iam_obj.del_apply(@tc_app_usr, @admin_token, @admin_id)
        }
    end

}
