#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_ApplicationCenter_005", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_manager_name     = "super@zhilutec.com"
        @tc_manager_nickname = "SUPER_MAN"
        @tc_manager_pwd      = "123456"

        @tc_app_name1        = "autotest_app1"
        @tc_app_name2        = "autotest_app2"
        @tc_app_name3        = "autotest_app3"
        @tc_app_name4        = "autotest_app4"
        @tc_app_provider     = "zhilutest"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            @rs  = {}
            @rs1 = {}
            @rs2 = {}
            @rs3 = {}
            @rs4 = {}
        }

        operate("2、获取登录用户的token值和id号；") {
            @rs = @iam_obj.manager_add(@tc_manager_name, @tc_manager_nickname, @tc_manager_pwd)
            assert_equal(1, @rs["result"], "创建超级管理员失败")

            p "知路超级管理员创建应用，并激活".encode("GBK")
            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args2 = {"name" => @tc_app_name2, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs1 = @iam_obj.qca_app(@tc_app_name1, args1, "1")
            assert_equal(1, @rs1["result"], "创建应用1失败")
            @rs2 = @iam_obj.qca_app(@tc_app_name2, args2, "1")
            assert_equal(1, @rs2["result"], "创建应用2失败")

            p "超级管理员创建应用，并激活".encode("GBK")
            args3 = {"name" => @tc_app_name3, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args4 = {"name" => @tc_app_name4, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs3 = @iam_obj.qca_app(@tc_app_name3, args3, "1", @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, @rs3["result"], "创建应用3失败")
            @rs4 = @iam_obj.qca_app(@tc_app_name4, args4, "1", @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, @rs4["result"], "创建应用4失败")

            app_name_arr = []
            flag         = false
            rs           = @iam_obj.usr_login_list_app_all(@ts_usr_name, @ts_usr_pwd)
            rs["apps"].each do |item|
                app_name_arr << item["name"]
            end
            flag = true if app_name_arr.include?(@tc_app_name1) && app_name_arr.include?(@tc_app_name2) && app_name_arr.include?(@tc_app_name3) && app_name_arr.include?(@tc_app_name4)
            assert(flag, "用户未查询到已激活的应用")
        }

        operate("3、用户查询待绑定的应用列表；") {
            rs1 = @iam_obj.mana_active_app(@tc_app_name1, "0")
            assert_equal(1, rs1["result"], "应用1禁用失败")
            rs2 = @iam_obj.mana_active_app(@tc_app_name2, "0")
            assert_equal(1, rs2["result"], "应用2禁用失败")
            rs3 = @iam_obj.mana_active_app(@tc_app_name3, "0", nil, @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, rs3["result"], "应用3禁用失败")
            rs4 = @iam_obj.mana_active_app(@tc_app_name4, "0", nil, @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, rs4["result"], "应用4禁用失败")

            app_name_arr = []
            flag         = true
            rs           = @iam_obj.usr_login_list_app_all(@ts_usr_name, @ts_usr_pwd)
            rs["apps"].each do |item|
                app_name_arr << item["name"]
            end
            flag = false if app_name_arr.include?(@tc_app_name1) || app_name_arr.include?(@tc_app_name2) || app_name_arr.include?(@tc_app_name3) || app_name_arr.include?(@tc_app_name4)
            assert(flag, "用户查询到未激活的应用")

            rs1 = @iam_obj.mana_active_app(@tc_app_name1, "1")
            assert_equal(1, rs1["result"], "应用1激活失败")
            rs2 = @iam_obj.mana_active_app(@tc_app_name2, "1")
            assert_equal(1, rs2["result"], "应用2激活失败")
            rs3 = @iam_obj.mana_active_app(@tc_app_name3, "1", nil, @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, rs3["result"], "应用3激活失败")
            rs4 = @iam_obj.mana_active_app(@tc_app_name4, "1", nil, @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, rs4["result"], "应用4激活失败")

            app_name_arr = []
            flag         = false
            rs           = @iam_obj.usr_login_list_app_all(@ts_usr_name, @ts_usr_pwd)
            rs["apps"].each do |item|
                app_name_arr << item["name"]
            end
            flag = true if app_name_arr.include?(@tc_app_name1) && app_name_arr.include?(@tc_app_name2) && app_name_arr.include?(@tc_app_name3) && app_name_arr.include?(@tc_app_name4)
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
            if @rs3["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name3)
            end
            if @rs4["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name4)
            end
            if @rs["result"] == 1
                @iam_obj.del_manager(@tc_manager_name)
            end
        }
    end

}
