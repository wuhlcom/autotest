#
# description:
# author:wuhongliang
# bug,�豸���м��пո�Ҳ����ӣ�����WEB�����ǲ�������ӵ�
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_036", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devnames  = [" Device1", "Device2 "]
    @tc_devname   = "Dev ice3"
    @tc_devmacs   = ["00:88:00:00:00:01", "00:88:00:00:E0:02"]
    @tc_devmac    = "00:88:00:00:A0:02"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
  end

  def process

    operate("1��ssh��¼IAM��������") {
      @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("2���û���¼��ȡ�û�uid�ţ�") {
    }

    operate("3���û�����豸mac���豸���ƴ��пո�") {
      @tc_devnames.each_with_index do |devname, index|
        tip = "�豸����Ϊ'#{devname}'"
        puts tip.to_gbk
        rs = @iam_obj.usr_add_devices(devname, @tc_devmacs[index], @tc_usr_phone, @tc_usr_pw)
        assert_equal(@ts_add_rs, rs["result"], "����豸ʧ��")
      end

      tip = "�豸����Ϊ'#{@tc_devname}'"
      puts tip.to_gbk
      p rs = @iam_obj.usr_add_devices(@tc_devname, @tc_devmac, @tc_usr_phone, @tc_usr_pw)
      puts "RESULT err_msg:'#{rs['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_devauth_msg, rs["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_devauth_code, rs["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_devauth_desc, rs["err_desc"], "#{tip}���ش���desc����ȷ!")
    }

  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      rs  = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      uid = rs["uid"]
      @tc_devnames.each_with_index do |dev_name|
        dev_name=dev_name.delete(" ")
        @iam_obj.qd_dev(dev_name, uid)
      end
    }
  end

}
