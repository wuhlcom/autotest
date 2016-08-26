#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_071", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_app_name1        = "application1"
        @tc_app_name2        = "application12"
        @tc_app_name3        = "app3"
        @tc_app_name4        = "lication4"
        @tc_app_name5        = "lication6"
        @tc_app_provider     = "zhilutest"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""
        @tc_dev_name         = "autotest_dev"
        @tc_dev_mac          = "00:1E:A2:00:01:51"
        @tc_err_code         = "40008"
    end

    def process

        operate("1、ssh登录到IAM服务器；") {
            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args2 = {"name" => @tc_app_name2, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args3 = {"name" => @tc_app_name3, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args4 = {"name" => @tc_app_name4, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args5 = {"name" => @tc_app_name5, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs1  = @iam_obj.qca_app(@tc_app_name1, args1, "1")
            assert_equal(1, @rs1["result"], "创建应用1失败")
            @rs2 = @iam_obj.qca_app(@tc_app_name2, args2, "1")
            assert_equal(1, @rs2["result"], "创建应用2失败")
            @rs3 = @iam_obj.qca_app(@tc_app_name3, args3, "1")
            assert_equal(1, @rs3["result"], "创建应用3失败")
            @rs4 = @iam_obj.qca_app(@tc_app_name4, args4, "1")
            assert_equal(1, @rs4["result"], "创建应用4失败")
            @rs5 = @iam_obj.qca_app(@tc_app_name5, args5, "1")
            assert_equal(1, @rs5["result"], "创建应用5失败")
        }

        operate("2、查询可以授权的应用列表；") {
            @rs = @iam_obj.usr_add_devices(@tc_dev_name, @tc_dev_mac, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs["result"], "用户增加设备失败")
        }

        operate("3、对设备授权5个应用；") {
            @client_id1 = @iam_obj.mana_get_client_id(@tc_app_name1)
            @client_id2 = @iam_obj.mana_get_client_id(@tc_app_name2)
            @client_id3 = @iam_obj.mana_get_client_id(@tc_app_name3)
            @client_id4 = @iam_obj.mana_get_client_id(@tc_app_name4)
            @client_id5 = @iam_obj.mana_get_client_id(@tc_app_name5)
            client_arr = []
            client_arr << @client_id1
            client_arr << @client_id2
            client_arr << @client_id3
            client_arr << @client_id4
            client_arr << @client_id5
            rs = @iam_obj.usr_dev_bindapp(@tc_dev_name, client_arr, @ts_usr_name, @ts_usr_pwd)
            assert_equal(@tc_err_code, rs["err_code"], "可以对设备授权5个应用")
        }

        operate("4、对设备授权4个应用；") {
            client_arr = []
            client_arr << @client_id1
            client_arr << @client_id2
            client_arr << @client_id3
            client_arr << @client_id4
            rs = @iam_obj.usr_dev_bindapp(@tc_dev_name, client_arr, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, rs["result"], "对设备授权4个应用时失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name, @ts_usr_name, @ts_usr_pwd)
            end

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
            if @rs5["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name5)
            end
        }
    end

}
