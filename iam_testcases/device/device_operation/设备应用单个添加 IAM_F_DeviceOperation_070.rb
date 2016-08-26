#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_070", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_app_name1        = "application1"
        @tc_app_provider     = "zhilutest"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""
        @tc_dev_name         = "autotest_dev"
        @tc_dev_mac          = "00:1E:A2:00:01:51"
    end

    def process

        operate("1、ssh登录到IAM服务器；") {
            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs1  = @iam_obj.qca_app(@tc_app_name1, args1, "1")
            assert_equal(1, @rs1["result"], "创建应用1并激活失败")
        }

        operate("2、查询可以授权的应用列表；") {
            @rs = @iam_obj.usr_add_devices(@tc_dev_name, @tc_dev_mac, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs["result"], "用户增加设备失败")
        }

        operate("3、对设备授权单个应用；") {
            client_id = @iam_obj.mana_get_client_id(@tc_app_name1)
            client_arr = []
            client_arr << client_id
            rs = @iam_obj.usr_dev_bindapp(@tc_dev_name, client_arr, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, rs["result"], "设备授权应用失败")
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
        }
    end

}
