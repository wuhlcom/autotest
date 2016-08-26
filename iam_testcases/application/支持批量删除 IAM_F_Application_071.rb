#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_071", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_app_usr1     = "autotest_new1"
        @tc_app_usr2     = "autotest_new2"
        @tc_app_provider = "autotest"
        @tc_app_red_uri  = "http://192.168.10.9"
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

        operate("3、获取应用列表，取出没有绑定应用和设备的应用ID号；") {
            #新创建两个应用，这两个应用就属于没有绑定设备的应用
            p "创建一个新应用".encode("GBK")
            args = {"name"=>@tc_app_usr1, "provider"=>@tc_app_provider, "redirect_uri"=>@tc_app_red_uri, "comments"=>""}
            rs   = @iam_obj.create_apply(@admin_id, @admin_token, args)
            assert_equal(1, rs["result"], "创建应用失败！")

            p "再次创建一个新应用".encode("GBK")
            args = {"name"=>@tc_app_usr2, "provider"=>@tc_app_provider, "redirect_uri"=>@tc_app_red_uri, "comments"=>""}
            rs   = @iam_obj.create_apply(@admin_id, @admin_token, args)
            assert_equal(1, rs["result"], "创建应用失败！")

        }

        operate("4、批量删除应用；") {
            appname = [@tc_app_usr1, @tc_app_usr2]
            rs = @iam_obj.del_apply(appname, @admin_token, @admin_id)
            assert_equal(1, rs["result"], "批量删除应用失败！")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
