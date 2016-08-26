#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_031", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname1  = "zhilutec_dev1"
    @tc_devname2  = "zhilutec_dev2"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
    @tc_devmac    = "00:88:A1:BB:CC:DD"
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("2���û���¼��ȡ�û�uid�ţ�") {
      rs = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs["result"], "�û���¼ʧ��!")
      @uid = rs["uid"]
    }

    operate("3���û�����豸A��mac��") {
      tip = "�û�����豸mac:'#{@tc_devmac}'"
      rs1 = @iam_obj.add_device(@tc_devname1, @tc_devmac, @uid)
      puts tip.to_gbk
      assert_equal(@ts_add_rs, rs1["result"], "#{tip}ʧ��!")
    }

    operate("4���ٴ�����豸A��mac��") {
      tip = "�û���һ������豸mac:'#{@tc_devmac}'"
      rs1 = @iam_obj.add_device(@tc_devname2, @tc_devmac, @uid)
      puts tip.to_gbk
      puts "RESULT err_msg:'#{rs1['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs1['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs1['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_devmac_msg, rs1["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_devmac_code, rs1["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_devmac_desc, rs1["err_desc"], "#{tip}���ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_device(@tc_devname1, @tc_usr_phone, @tc_usr_pw)
      @iam_obj.usr_delete_device(@tc_devname2, @tc_usr_phone, @tc_usr_pw)
    }
  end

}
