#
# description:
# MAC��ַ�����д�С������ʾӦ��ͳһΪ��д
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_029", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devnames  = %w(zhilutec_dev1 zhilutec_dev2 zhilutec_dev3)
    @tc_args      = {type: "account", cond: @tc_usr_phone}
    @tc_devmacs   = %w(00:88:A1:BB:CC:DD 00:88:a2:bb:cc:de 00:88:Aa:Bb:Cc:Dd)
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2���û���¼��ȡ�û�uid�ţ�") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("3���û�����豸mac��") {
      rs = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs["result"], "�û���¼ʧ��!")
      uid = rs["uid"]

      @tc_devmacs.each_with_index do |devmac, index|
        rs1 = @iam_obj.add_device(@tc_devnames[index], devmac, uid)
        tip = "�û�����豸mac'#{devmac}'"
        puts tip.to_gbk
        assert_equal(@ts_add_rs, rs1["result"], "#{tip}ʧ��!")
        devinfo = @iam_obj.get_spec_dev_info(@tc_devnames[index], uid)
        assert_equal(devmac.upcase, devinfo["device_mac"], "#{tip}ʧ��!")
      end
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      rs  = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      uid = rs["uid"]
      @tc_devnames.each_with_index do |dev_name|
        @iam_obj.qd_dev(dev_name, uid)
      end
    }
  end

}
