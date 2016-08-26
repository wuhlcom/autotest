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
        @name_editor  = "����·֪��¥B��3¥����·֪��¥B��3¥����·֪��¥B��3¥125"
        p "�����豸�����ַ�����#{@name_editor.size}".encode("GBK")
        @tc_dev_mac1 = "00:1a:31:00:01:77"
        @tc_err_code = ""
    end

    def process

        operate("1��ssh��¼IAM��������") {
            @rs1 = @iam_obj.usr_add_devices(@tc_dev_name1, @tc_dev_mac1, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs1["result"], "�û�1�����豸ʧ��")
        }

        operate("2����ȡ��¼�û�uid�ţ�") {
        }

        operate("3����ȡ¼���豸A��device_id�ţ�") {
        }

        operate("4���༭�豸A����Ϊ33�ַ���ϣ�") {
            p @rs = @iam_obj.usr_device_editor(@ts_usr_name, @ts_usr_pwd, @tc_dev_name1, @name_editor)
            assert_equal(@tc_err_code, @rs["err_code"], "�û�1Ϊ33���ַ�ʱ�������豸�ɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_device(@name_editor, @ts_usr_name, @ts_usr_pwd)
            elsif @rs1["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name1, @ts_usr_name, @ts_usr_pwd)
            end
        }
    end

}
