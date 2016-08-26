#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_050", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_dev_name2 = "autotest_dev2"
        @tc_dev_mac2  = "00:1a:31:00:01:78"
        @name_editor2 = ""
        @tc_err_code  = "40006"
    end

    def process

        operate("1��ssh��¼IAM��������") {
            @rs2 = @iam_obj.usr_add_devices(@tc_dev_name2, @tc_dev_mac2, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs2["result"], "�û�2�����豸ʧ��")
        }

        operate("2����ȡ��¼�û�uid�ţ�") {
        }

        operate("3����ȡ¼���豸A��device_id�ţ�") {
        }

        operate("4���༭�豸A����Ϊ�գ�") {
            p @rss2 = @iam_obj.usr_device_editor(@ts_usr_name, @ts_usr_pwd, @tc_dev_name2, @name_editor2)
            assert_equal(@tc_err_code, @rss2["err_code"], "�޸��豸����Ϊ�ճɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rss2["result"] == 1
                @iam_obj.usr_delete_device(@name_editor2, @ts_usr_name, @ts_usr_pwd)
            elsif @rs2["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name2, @ts_usr_name, @ts_usr_pwd)
            end
        }
    end

}
