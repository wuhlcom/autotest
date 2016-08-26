#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_053", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_dev_name1 = "mark_dev1"
        @tc_dev_mac1  = "00:1a:31:00:01:77"
        @tc_dev_name2 = "mark_dev2"
        @tc_dev_mac2  = "00:1a:31:00:01:78"
        @tc_err_code  = "40009"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录用户uid号；") {

        }

        operate("3、获取录入设备A的device_id号；") {
            @rs1 = @iam_obj.usr_add_devices(@tc_dev_name1, @tc_dev_mac1, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs1["result"], "用户1增加设备失败")
            @rs2 = @iam_obj.usr_add_devices(@tc_dev_name2, @tc_dev_mac2, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs2["result"], "用户1增加设备失败")
        }

        operate("4、编辑设备A名称为已存在的名称；") {
            @rss1 = @iam_obj.usr_device_editor(@ts_usr_name, @ts_usr_pwd, @tc_dev_name1, @tc_dev_name2)
            assert_equal(@tc_err_code, @rss1["err_code"], "修改已存在的设备名称成功")
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
        }
    end

}
