#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_051", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_usr   = "15859071512"
        @tc_usr_pw      = "123456"
        @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}

        @tc_dev_name1 = "autotest_dev1"
        @name_editor  = "爱国路知青楼B栋3楼爱国路知青楼B栋3楼爱国路知青楼B栋3楼125"
        p "输入设备名称字符数：#{@name_editor.size}".encode("GBK")
        @tc_dev_mac1 = "00:1a:31:00:01:77"
        @tc_err_code = ""
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")

            @rs1 = @iam_obj.usr_add_devices(@tc_dev_name1, @tc_dev_mac1, @tc_phone_usr, @tc_usr_pw)
            assert_equal(1, @rs1["result"], "用户1增加设备失败")
        }

        operate("2、获取登录用户uid号；") {
        }

        operate("3、获取录入设备A的device_id号；") {
        }

        operate("4、编辑设备A名称为33字符组合；") {
            tip = "编辑设备A名称为33字符组合"
            p rs = @iam_obj.usr_device_editor(@tc_phone_usr, @tc_usr_pw, @tc_dev_name1, @name_editor)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_devexists_code, rs["err_code"], "#{tip}返回code错误!")
            assert_equal(@ts_err_devexists_msg, rs["err_msg"], "#{tip}返回msg错误")
            assert_equal(@ts_err_devexists_desc, rs["err_desc"], "#{tip}返回desc错误!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_delete_device(@name_editor, @tc_phone_usr, @tc_usr_pw)
            @iam_obj.usr_delete_device(@tc_dev_name1, @tc_phone_usr, @tc_usr_pw)
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
        }
    end

}
