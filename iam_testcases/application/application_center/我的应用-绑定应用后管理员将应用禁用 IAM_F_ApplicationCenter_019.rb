#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_ApplicationCenter_019", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_app_name1        = "application1"
        @tc_app_provider     = "zhilutest"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""
    end

    def process

        operate("1、ssh登录服务器；") {
            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs1  = @iam_obj.qca_app(@tc_app_name1, args1, "1")
            assert_equal(1, @rs1["result"], "创建应用1失败")
        }

        operate("2、知路管理员禁用该应用；") {
            @rss1 = @iam_obj.usr_qb_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name1)
            assert_equal(1, @rss1["result"], "用户绑定应用1失败")

            rs3 = @iam_obj.usr_login_list_app_bytype(@ts_usr_name, @ts_usr_pwd, @tc_app_name1, false)
            assert_equal(@tc_app_name1, rs3["apps"][0]["name"], "绑定应用后，不可以查询到应用")
        }

        operate("3、用户查询我的应用；") {
            @res = @iam_obj.mana_active_app(@tc_app_name1, "0")
            assert_equal(1, @res["result"], "应用1禁用失败")

            rs3 = @iam_obj.usr_login_list_app_bytype(@ts_usr_name, @ts_usr_pwd, @tc_app_name1, false)
            assert_equal("0", rs3["totalRows"], "禁用应用后，可以查询到应用")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @res["result"] == 1
                p @iam_obj.mana_active_app(@tc_app_name1, "1")
                p @iam_obj.usr_qub_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name1)
            end

            if @rs1["result"] == 1
                p @iam_obj.mana_del_app(@tc_app_name1)
            end
        }
    end

}
