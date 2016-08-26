#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_057", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_dev_name1 = "mark_dev1"
        @tc_dev_mac1  = "00:1a:31:00:01:77"
        @tc_dev_name2 = "mark_dev2"
        @tc_dev_mac2  = "00:1a:31:00:01:78"
        @tc_dev_name3 = "att_dev1"
        @tc_dev_mac3  = "00:1a:31:00:01:79"
        @tc_dev_name4 = "att_dev2"
        @tc_dev_mac4  = "00:1e:a2:00:01:51"
        @name1        = "mark_dev1"
        @name2        = "att_dev1"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            @rs1 = @iam_obj.usr_add_devices(@tc_dev_name1, @tc_dev_mac1, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs1["result"], "用户1增加设备失败")
            @rs2 = @iam_obj.usr_add_devices(@tc_dev_name2, @tc_dev_mac2, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs2["result"], "用户2增加设备失败")
            @rs3 = @iam_obj.usr_add_devices(@tc_dev_name3, @tc_dev_mac3, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs3["result"], "用户3增加设备失败")
            @rs4 = @iam_obj.usr_add_devices(@tc_dev_name4, @tc_dev_mac4, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs4["result"], "用户4增加设备失败")
        }

        operate("2、获取登录用户uid号；") {
            args = {"type" => "name", "cond" => @name1}
            rs   = @iam_obj.usr_get_devlist(@ts_usr_name, @ts_usr_pwd, args)
            assert_equal(@name1, rs["resList"][0]["device_name"], "未查询到相关设备")
        }

        operate("3、查询设备名称为知路科技公司的设备信息；") {
            args = {"type" => "name", "cond" => @name2}
            rs   = @iam_obj.usr_get_devlist(@ts_usr_name, @ts_usr_pwd, args)
            assert_equal(@name2, rs["resList"][0]["device_name"], "未查询到相关设备")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs1["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name1, @ts_usr_name, @ts_usr_pwd)
            end
            if @rs2["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name2, @ts_usr_name, @ts_usr_pwd)
            end
            if @rs3["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name3, @ts_usr_name, @ts_usr_pwd)
            end
            if @rs4["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name4, @ts_usr_name, @ts_usr_pwd)
            end
        }
    end

}
