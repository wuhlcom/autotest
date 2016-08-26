#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_ApplicationCenter_002", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_manager_name     = "super@zhilutec.com"
        @tc_manager_nickname = "SUPER_MAN"
        @tc_manager_pwd      = "123456"

        @tc_app_name1        = "autotest_app1"
        @tc_app_name2        = "autotest_app2"
        @tc_app_provider     = "zhilutest"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录用户的token值和id号；") {
            @rs = @iam_obj.manager_add(@tc_manager_name, @tc_manager_nickname, @tc_manager_pwd)
            assert_equal(1, @rs["result"], "创建管理员失败")

            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args2 = {"name" => @tc_app_name2, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs1    = @iam_obj.qca_app(@tc_app_name1, args1, "1", @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, @rs1["result"], "创建应用1并激活失败")
            @rs2    = @iam_obj.qca_app(@tc_app_name2, args2, "1", @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, @rs2["result"], "创建应用2并激活失败")
        }

        operate("3、用户查询待绑定的应用列表；") {
            app_name_arr = []
            flag = false
            rs = @iam_obj.usr_login_list_app_all(@ts_usr_name, @ts_usr_pwd)
            rs["apps"].each do |item|
                app_name_arr << item["name"]
            end
            flag = true if app_name_arr.include?(@tc_app_name1) && app_name_arr.include?(@tc_app_name2)
            assert(flag, "用户未查询到已激活的应用")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs1["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name1)
            end
            if @rs2["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name2)
            end
            if @rs["result"] == 1
                @iam_obj.del_manager(@tc_manager_name)
            end
        }
    end

}
