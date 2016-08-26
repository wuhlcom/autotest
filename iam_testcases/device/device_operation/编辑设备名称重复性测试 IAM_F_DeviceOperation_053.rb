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

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼�û�uid�ţ�") {

        }

        operate("3����ȡ¼���豸A��device_id�ţ�") {
            @rs1 = @iam_obj.usr_add_devices(@tc_dev_name1, @tc_dev_mac1, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs1["result"], "�û�1�����豸ʧ��")
            @rs2 = @iam_obj.usr_add_devices(@tc_dev_name2, @tc_dev_mac2, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs2["result"], "�û�1�����豸ʧ��")
        }

        operate("4���༭�豸A����Ϊ�Ѵ��ڵ����ƣ�") {
            @rss1 = @iam_obj.usr_device_editor(@ts_usr_name, @ts_usr_pwd, @tc_dev_name1, @tc_dev_name2)
            assert_equal(@tc_err_code, @rss1["err_code"], "�޸��Ѵ��ڵ��豸���Ƴɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs1["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name1, @ts_usr_name, @ts_usr_pwd)
            end
            if @rs2["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name2, @ts_usr_name, @ts_usr_pwd)
            end
        }
    end

}
