#
# description:
# ֻ֧��ð�����ֶ�
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_026", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_usr_phone      = "13700001111"
    @tc_usr_pw         = "123456"
    @tc_devname1       = "zhilutec_dev1"
    @tc_devmac1        = "00:88:00:00:00:01"
    @tc_devmac_format2 = @tc_devmac1.gsub(":", "-")
    @tc_devmac_format3 = @tc_devmac1.sub(":", "-")
    @tc_devmac_format4 = @tc_devmac1.delete(":")
    @tc_args           = {type: "account", cond: @tc_usr_phone}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2���û���¼��ȡ�û�uid�ţ�") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("3���û�����豸mac�������ƶ�һ�£�ֻ����ð�ż������") {
      rs = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs["result"], "�û���¼ʧ��!")

      uid = rs["uid"]
      tip ="�û�����豸macΪ��#{@tc_devmac1}��"
      puts tip.to_gbk
      rs1 = @iam_obj.add_device(@tc_devname1, @tc_devmac1, uid)
      assert_equal(@ts_add_rs, rs1["result"], "#{tip}ʧ��!")
      @iam_obj.qd_dev(@tc_devname1, uid)

      tip ="�û�����豸macΪ��#{@tc_devmac_format2}��"
      puts tip.to_gbk
      rs2 = @iam_obj.add_device(@tc_devname1, @tc_devmac_format2, uid)
      puts "RESULT err_msg:'#{rs2['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs2['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs2['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_devauth_msg, rs2["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_devauth_code, rs2["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_devauth_desc, rs2["err_desc"], "#{tip}���ش���desc����ȷ!")

      tip ="�û�����豸macΪ��#{@tc_devmac_format3}��"
      puts tip.to_gbk
      rs3 = @iam_obj.add_device(@tc_devname1, @tc_devmac_format3, uid)
      puts "RESULT err_msg:'#{rs3['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs3['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs3['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_devauth_msg, rs3["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_devauth_code, rs3["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_devauth_desc, rs3["err_desc"], "#{tip}���ش���desc����ȷ!")

      tip ="�û�����豸macΪ��#{@tc_devmac_format4}��"
      puts tip.to_gbk
      rs4 = @iam_obj.add_device(@tc_devname1, @tc_devmac_format4, uid)
      puts "RESULT err_msg:'#{rs4['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs4['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs4['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_devauth_msg, rs4["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_devauth_code, rs4["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_devauth_desc, rs4["err_desc"], "#{tip}���ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_device(@tc_devname1, @tc_usr_phone, @tc_usr_pw)
    }
  end

}
