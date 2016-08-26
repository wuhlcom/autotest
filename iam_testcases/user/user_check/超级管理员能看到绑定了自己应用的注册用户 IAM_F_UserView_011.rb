#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserView_011", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_superapp_usr  = "autotest_super"
        @tc_app_provider  = "autotest"
        @tc_app_red_uri   = "http://192.168.10.9"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            p "创建一个超级管理员账户".encode("GBK")
            rs = @iam_obj.manager_del_add(@ts_app_super_manage, @ts_app_manage_pwd, @ts_app_super_manage_nickname)
            assert_equal(1, rs["result"], "创建超级管理员失败！")
            p "创建一个新应用".encode("GBK")
            args = {"name" => @tc_superapp_usr, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_red_uri, "comments" => ""}
            rs   = @iam_obj.mana_create_app(args, "1", @ts_app_super_manage, @ts_app_manage_pwd)
            assert_equal(1, rs["result"], "超级管理员创建应用失败！")
        }

        operate("2、获取超级管理员token值；") {
            p "用户#{@ts_usr_name},绑定超级管理员创建的应用#{@tc_superapp_usr}".encode("GBK")
            @client_id = @iam_obj.mana_get_client_id(@tc_superapp_usr, nil, @ts_app_super_manage, @ts_app_manage_pwd)
            @rs_bind   = @iam_obj.usr_qb_app(@ts_usr_name, @ts_usr_pwd, @tc_superapp_usr)
            assert_equal(1, @rs_bind["result"], "用户绑定应用失败")
        }

        operate("3、获取所有用户列表；") {
            @res = @iam_obj.manager_login(@ts_app_super_manage, @ts_app_manage_pwd)
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]

            rs = @iam_obj.get_user_list(@admin_id, @admin_token)
            flag = false
            rs["users"].each do |usr|
                flag = true if usr["account"] == @ts_usr_name
            end
            assert(flag, "不能获取绑定了超级管理员创建应用的用户")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs_bind["result"] == 1
                data = {"client_id" => @client_id}
                @iam_obj.login_unbinding_app(@ts_usr_name, @ts_usr_pwd, data)
            end
            @iam_obj.mana_del_app(@tc_superapp_usr)
            @iam_obj.del_manager(@ts_app_super_manage)
        }
    end

}
