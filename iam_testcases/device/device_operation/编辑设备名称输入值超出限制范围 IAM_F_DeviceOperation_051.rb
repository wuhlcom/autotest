#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_051", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_dev_name1 = "autotest_dev1"
        @name_editor  = "爱国路知青楼B栋3楼爱国路知青楼B栋3楼爱国路知青楼B栋3楼125"
        p "输入设备名称字符数：#{@name_editor.size}".encode("GBK")
        @tc_dev_mac1 = "00:1a:31:00:01:77"
        @tc_err_code = ""
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            @rs1 = @iam_obj.usr_add_devices(@tc_dev_name1, @tc_dev_mac1, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs1["result"], "用户1增加设备失败")
        }

        operate("2、获取登录用户uid号；") {
        }

        operate("3、获取录入设备A的device_id号；") {
        }

        operate("4、编辑设备A名称为33字符组合；") {
            p @rs = @iam_obj.usr_device_editor(@ts_usr_name, @ts_usr_pwd, @tc_dev_name1, @name_editor)
            assert_equal(@tc_err_code, @rs["err_code"], "用户1为33个字符时，增加设备成功")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_device(@name_editor, @ts_usr_name, @ts_usr_pwd)
            elsif @rs1["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name1, @ts_usr_name, @ts_usr_pwd)
            end
        }
    end

}
