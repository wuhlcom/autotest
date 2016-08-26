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

        operate("1��ssh��¼IAM��������") {
            p @rs1 = @iam_obj.usr_add_devices(@tc_dev_name1, @tc_dev_mac1, @ts_usr_name, @ts_usr_pwd)
            p @rs1["err_msg"].encode("GBK") unless @rs1["err_msg"].nil?
            assert_equal(1, @rs1["result"], "�û�1�����豸ʧ��")
            p @rs2 = @iam_obj.usr_add_devices(@tc_dev_name2, @tc_dev_mac2, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs2["result"], "�û�2�����豸ʧ��")
        }

        operate("2����ȡ��¼�û�uid�ţ�") {
        }

        operate("3����ȡ¼���豸A��device_id�ţ�") {
        }

        operate("4���༭�豸A����Ϊ���пո�") {
            p @rss1 = @iam_obj.usr_device_editor(@ts_usr_name, @ts_usr_pwd, @tc_dev_name1, @name_editor1)
            assert_equal(@tc_err_code, @rss1["err_code"], "�޸��豸����Ϊ�ո�ɹ�")

            p @rss2 = @iam_obj.usr_device_editor(@ts_usr_name, @ts_usr_pwd, @tc_dev_name2, @name_editor2)
            assert_equal(@tc_err_code, @rss2["err_code"], "�޸��豸����Ϊ�ո�+���ֳɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
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
