#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_057", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_dev_name1 = "mark_dev1"
        @tc_dev_mac1  = "00:1a:31:00:01:77"
        @tc_dev_name2 = "mark_dev2"
        @tc_dev_mac2  = "00:1a:31:00:01:78"
        @tc_dev_name3 = "att_dev1"
        @tc_dev_mac3  = "00:1a:31:00:01:79"
        @tc_dev_name4 = "att_dev2"
        @tc_dev_mac4  = "00:1e:a2:00:01:51"
        @name1        = "mark_dev1"
        @name2        = "att_dev1"
        @tc_dev_name_arr = [@tc_dev_name1, @tc_dev_name2, @tc_dev_name3, @tc_dev_name4]
        @tc_dev_mac_arr  = [@tc_dev_mac1, @tc_dev_mac2, @tc_dev_mac3, @tc_dev_mac4]
    end

    def process

        operate("1��ssh��¼IAM��������") {
            @rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
            assert_equal(@ts_add_rs, @rs["result"], "�û�#{@ts_phone_usr}ע��ʧ��")

            @tc_dev_name_arr.each_with_index do |name, index|
                rs = @iam_obj.usr_add_devices(name, @tc_dev_mac_arr[index], @ts_phone_usr, @ts_usr_pw)
                assert_equal(@ts_add_rs, rs["result"], "�û�#{name}�����豸ʧ��,�豸macΪ:#{@tc_dev_mac_arr[index]}")
            end
        }

        operate("2����ȡ��¼�û�uid�ţ�") {
            args = {"type" => "name", "cond" => @name1}
            rs   = @iam_obj.usr_get_devlist(@ts_phone_usr, @ts_usr_pw, args)
            assert_equal(@name1, rs["resList"][0]["device_name"], "δ��ѯ������豸")
        }

        operate("3����ѯ�豸����Ϊ֪·�Ƽ���˾���豸��Ϣ��") {
            args = {"type" => "name", "cond" => @name2}
            rs   = @iam_obj.usr_get_devlist(@ts_phone_usr, @ts_usr_pw, args)
            assert_equal(@name2, rs["resList"][0]["device_name"], "δ��ѯ������豸")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @tc_dev_name_arr.each do |name|
                @iam_obj.usr_delete_device(name, @ts_phone_usr, @ts_usr_pw)
            end
            @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
        }
    end

}
