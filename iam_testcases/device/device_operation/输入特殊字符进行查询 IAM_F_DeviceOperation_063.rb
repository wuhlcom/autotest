#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_063", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_dev_name = "autotest_dev"
        @tc_dev_mac  = "00:1E:A2:00:01:51"
        @name        = "`!@#$%^&*()_+{}:\"|<>?-=[];'\\,./~"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼�û�uid�ţ�") {
            @rs = @iam_obj.usr_add_devices(@tc_dev_name, @tc_dev_mac, @ts_usr_name, @ts_usr_pwd)
            assert_equal(1, @rs["result"], "�û������豸ʧ��")
        }

        operate("3�����豸���Ʋ�ѯ�����������ַ���") {
            args = {"type" => "name", "cond" => @name}
            rs   = @iam_obj.usr_get_devlist(@ts_usr_name, @ts_usr_pwd, args, "true")
            assert_equal("0", rs["totalRows"], "���豸���Ʋ�ѯ�����������ַ����ܲ�ѯ���豸")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_device(@tc_dev_name, @ts_usr_name, @ts_usr_pwd)
            end
        }
    end

}
