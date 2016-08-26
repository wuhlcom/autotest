#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_063", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_dev_name = "autotest_dev"
        @tc_dev_mac  = "00:1E:A2:00:01:51"
        @name        = "`!@#$%^&*()_+{}:\"|<>?-=[];'\\,./~"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录用户uid号；") {
            @rs = @iam_obj.usr_add_devices(@tc_dev_name, @tc_dev_mac, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs["result"], "用户增加设备失败")
        }

        operate("3、按设备名称查询，输入特殊字符；") {
            args = {"type" => "name", "cond" => @name}
            rs   = @iam_obj.usr_get_devlist(@ts_usr_name, @ts_usr_pwd, args, "true")
            assert_equal("0", rs["totalRows"], "按设备名称查询，输入特殊字符，能查询到设备")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name, @ts_usr_name, @ts_usr_pwd)
            end
        }
    end

}
