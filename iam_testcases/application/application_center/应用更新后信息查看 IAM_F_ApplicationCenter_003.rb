#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_ApplicationCenter_003", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_app_name1        = "autotest_app1"
        @tc_app_name2        = "autotest_app2"
        @tc_app_provider     = "zhilutest"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""
        @tc_app_comments_ch  = "HaHaHaHa"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录用户的token值和id号；") {
            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args2 = {"name" => @tc_app_name2, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs1  = @iam_obj.qca_app(@tc_app_name1, args1, "1")
            assert_equal(1, @rs1["result"], "创建应用1并激活失败")
            @rs2 = @iam_obj.qca_app(@tc_app_name2, args2, "1")
            assert_equal(1, @rs2["result"], "创建应用2并激活失败")
        }

        operate("3、用户查询待绑定的应用列表；") {

        }

        operate("4、知路管理员员修改应用信息；") {
            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments_ch}
            rs1 = @iam_obj.mana_mod_app(@tc_app_name1, args1)
            assert_equal(1, rs1["result"], "修改应用1信息失败")
            args2 = {"name" => @tc_app_name2, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments_ch}
            rs2 = @iam_obj.mana_mod_app(@tc_app_name2, args2)
            assert_equal(1, rs2["result"], "修改应用2信息失败")
        }

        operate("5、用户查询待绑定的应用列表；") {
            rs1 = @iam_obj.check_app_details(@tc_app_name1)
            assert_equal(@tc_app_comments_ch, rs1["comments"], "应用1查询成功")
            rs2 = @iam_obj.check_app_details(@tc_app_name2)
            assert_equal(@tc_app_comments_ch, rs2["comments"], "应用2查询成功")
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
        }
    end

}
