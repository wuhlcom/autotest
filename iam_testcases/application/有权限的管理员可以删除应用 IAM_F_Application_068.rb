#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_068", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_superapp_usr  = "autotest_super"
        @tc_systemapp_usr = "autotest_system"
        @tc_app_provider  = "autotest"
        @tc_app_red_uri   = "http://192.168.10.9"
        @tc_err_code      = "22013"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取知路管理员token值；") {
            p "创建一个超级管理员账户".encode("GBK")
            rs = @iam_obj.manager_del_add(@ts_app_super_manage, @ts_app_manage_pwd, @ts_app_super_manage_nickname)
            assert_equal(1, rs["result"], "创建超级管理员失败！")
            p "创建一个系统管理员账户".encode("GBK")
            rs = @iam_obj.manager_del_add(@ts_app_system_manage, @ts_app_manage_pwd, @ts_app_system_manage_nickname, "3")
            assert_equal(1, rs["result"], "创建系统管理员失败！")
        }

        operate("3、获取要删除应用ID号；") {
            p "创建一个新应用".encode("GBK")
            args = {"name" => @tc_superapp_usr, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_red_uri, "comments" => ""}
            rs   = @iam_obj.mana_create_app(args, "0", @ts_app_super_manage, @ts_app_manage_pwd)
            assert_equal(1, rs["result"], "超级管理员创建应用失败！")

            args = {"name" => @tc_systemapp_usr, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_red_uri, "comments" => ""}
            rs   = @iam_obj.mana_create_app(args, "0", @ts_app_system_manage, @ts_app_manage_pwd)
            assert_equal(1, rs["result"], "系统管理员创建应用失败！")
        }

        operate("4、知路管理员删除该应用；") {
            rs = @iam_obj.mana_del_app(@tc_superapp_usr, nil, @ts_app_super_manage, @ts_app_manage_pwd)
            assert_equal(1, rs["result"], "超级管理员删除应用失败！")
        }

        operate("5、登录一个系统管理员，获取该系统管理员的token值；") {

        }

        operate("6、系统管理员删除一个应用；") {
            rs = @iam_obj.mana_del_app(@tc_systemapp_usr, nil, @ts_app_system_manage, @ts_app_manage_pwd)
            assert_equal(@tc_err_code, rs["err_code"], "系统管理员删除应用失败后返回的错误码不正确！")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.mana_del_app(@tc_superapp_usr)
            @iam_obj.mana_del_app(@tc_systemapp_usr)

            @iam_obj.del_manager(@ts_app_super_manage)
            @iam_obj.del_manager(@ts_app_system_manage)
        }
    end

}
