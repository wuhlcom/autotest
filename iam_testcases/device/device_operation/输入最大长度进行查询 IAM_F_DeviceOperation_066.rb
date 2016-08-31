#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_066", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_usr    = "13702044444"
        @tc_usr_pw       = "123456"
        @tc_usr_regargs  = {type: "account", cond: @tc_phone_usr}
        
        @tc_dev_name = "DeviceABDeviceABDeviceABDeviceAB"
        @tc_dev_mac  = "00:1E:A2:00:01:51"
    end

    def process

        operate("1��ssh��¼IAM��������") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")
        }

        operate("2����ȡ��¼�û�uid�ţ�") {
            @rs = @iam_obj.usr_add_devices(@tc_dev_name, @tc_dev_mac, @tc_phone_usr, @tc_usr_pw)
            assert_equal(1, @rs["result"], "�û������豸ʧ��")
        }

        operate("3�����豸���Ʋ�ѯ���豸����Ϊ32λ��") {
            args = {"type" => "name", "cond" => @tc_dev_name}
            rs   = @iam_obj.usr_get_devlist(@tc_phone_usr, @tc_usr_pw, args)
            assert_equal(@tc_dev_name, rs["resList"][0]["device_name"], "�豸����Ϊ32λʱ�����豸����ѯδ�ܲ�ѯ�����豸")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
        }
    end

}
