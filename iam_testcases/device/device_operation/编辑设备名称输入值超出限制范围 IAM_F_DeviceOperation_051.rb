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
        @name_editor  = "����·֪��¥B��3¥����·֪��¥B��3¥����·֪��¥B��3¥125"
        p "�����豸�����ַ�����#{@name_editor.size}".encode("GBK")
        @tc_dev_mac1 = "00:1a:31:00:01:77"
        @tc_err_code = ""
    end

    def process

        operate("1��ssh��¼IAM��������") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")

            @rs1 = @iam_obj.usr_add_devices(@tc_dev_name1, @tc_dev_mac1, @tc_phone_usr, @tc_usr_pw)
            assert_equal(1, @rs1["result"], "�û�1�����豸ʧ��")
        }

        operate("2����ȡ��¼�û�uid�ţ�") {
        }

        operate("3����ȡ¼���豸A��device_id�ţ�") {
        }

        operate("4���༭�豸A����Ϊ33�ַ���ϣ�") {
            tip = "�༭�豸A����Ϊ33�ַ����"
            p rs = @iam_obj.usr_device_editor(@tc_phone_usr, @tc_usr_pw, @tc_dev_name1, @name_editor)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_devexists_code, rs["err_code"], "#{tip}����code����!")
            assert_equal(@ts_err_devexists_msg, rs["err_msg"], "#{tip}����msg����")
            assert_equal(@ts_err_devexists_desc, rs["err_desc"], "#{tip}����desc����!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.usr_delete_device(@name_editor, @tc_phone_usr, @tc_usr_pw)
            @iam_obj.usr_delete_device(@tc_dev_name1, @tc_phone_usr, @tc_usr_pw)
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
        }
    end

}
