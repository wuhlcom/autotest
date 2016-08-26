#
# description:
# bug�����볬��32���ֽڵ��豸��
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_035", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname   = "qwertHHHHH"*3+"111"
    @tc_devmac    = "00:88:AA:BB:CC:DD"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("2���û���¼��ȡ�û�uid�ţ�") {
    }

    operate("3���û�����豸mac���豸����Ϊ33�ַ���") {
      tip = "�豸����Ϊ#{@tc_devname.size}�ַ�"
      puts tip.to_gbk
      p rs = @iam_obj.usr_add_devices(@tc_devname, @tc_devmac, @tc_usr_phone, @tc_usr_pw)
      puts "RESULT err_msg:'#{rs['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_devnul_msg, rs["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_devnul_code, rs["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_devnul_desc, rs["err_desc"], "#{tip}���ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_device(@tc_devname, @tc_usr_phone, @tc_usr_pw)
    }
  end

}
