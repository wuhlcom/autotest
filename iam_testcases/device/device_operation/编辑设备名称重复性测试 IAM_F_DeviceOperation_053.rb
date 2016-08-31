#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_053", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_usr   = "15859071512"
        @tc_usr_pw      = "123456"
        @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}
        @tc_dev_name1   = "mark_dev1"
        @tc_dev_mac1    = "00:1a:31:00:01:77"
        @tc_dev_name2   = "mark_dev2"
        @tc_dev_mac2    = "00:1a:31:00:01:78"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")
        }

        operate("2、获取登录用户uid号；") {

        }

        operate("3、获取录入设备A的device_id号；") {
            @rs1 = @iam_obj.usr_add_devices(@tc_dev_name1, @tc_dev_mac1, @tc_phone_usr, @tc_usr_pw)
            assert_equal(1, @rs1["result"], "用户1增加设备失败")
            @rs2 = @iam_obj.usr_add_devices(@tc_dev_name2, @tc_dev_mac2, @tc_phone_usr, @tc_usr_pw)
            assert_equal(1, @rs2["result"], "用户1增加设备失败")
        }

        operate("4、编辑设备A名称为已存在的名称；") {
            tip = "编辑设备A名称为已存在的名称"
            rs = @iam_obj.usr_device_editor(@tc_phone_usr, @tc_usr_pw, @tc_dev_name1, @tc_dev_name2)
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
            @iam_obj.usr_delete_device(@tc_dev_name1, @tc_phone_usr, @tc_usr_pw)
            @iam_obj.usr_delete_device(@tc_dev_name2, @tc_phone_usr, @tc_usr_pw)
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
        }
    end

}
