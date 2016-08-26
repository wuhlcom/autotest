#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_052", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_dev_name1 = "autotest_dev1"
        @tc_dev_mac1  = "00:1a:31:00:01:77"
        @tc_dev_name2 = "autotest_dev2"
        @tc_dev_mac2  = "00:1a:31:00:01:78"
        @name_editor1 = " "
        @name_editor2 = "ab cd er"
        @tc_err_code  = ""
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            p @rs1 = @iam_obj.usr_add_devices(@tc_dev_name1, @tc_dev_mac1, @ts_usr_name, @ts_usr_pwd)
            p @rs1["err_msg"].encode("GBK") unless @rs1["err_msg"].nil?
            assert_equal(1, @rs1["result"], "用户1增加设备失败")
            p @rs2 = @iam_obj.usr_add_devices(@tc_dev_name2, @tc_dev_mac2, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs2["result"], "用户2增加设备失败")
        }

        operate("2、获取登录用户uid号；") {
        }

        operate("3、获取录入设备A的device_id号；") {
        }

        operate("4、编辑设备A名称为带有空格；") {
            p @rss1 = @iam_obj.usr_device_editor(@ts_usr_name, @ts_usr_pwd, @tc_dev_name1, @name_editor1)
            assert_equal(@tc_err_code, @rss1["err_code"], "修改设备名称为空格成功")

            p @rss2 = @iam_obj.usr_device_editor(@ts_usr_name, @ts_usr_pwd, @tc_dev_name2, @name_editor2)
            assert_equal(@tc_err_code, @rss2["err_code"], "修改设备名称为空格+文字成功")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rss1["result"] == 1
                @iam_obj.usr_delete_device(@name_editor1, @ts_usr_name, @ts_usr_pwd)
            elsif @rs1["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name1, @ts_usr_name, @ts_usr_pwd)
            end

            if @rss2["result"] == 1
                @iam_obj.usr_delete_device(@name_editor2, @ts_usr_name, @ts_usr_pwd)
            elsif @rs2["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name2, @ts_usr_name, @ts_usr_pwd)
            end
        }
    end

}
