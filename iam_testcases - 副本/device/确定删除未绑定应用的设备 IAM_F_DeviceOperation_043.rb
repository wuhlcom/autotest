#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_043", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname   = "yinyin"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
    @tc_devmac1   = "00:88:00:00:00:01"
  end

  def process

    operate("1��ssh��¼IAM��������") {
      @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("2����ȡ��¼�û���uid�ţ�") {
      rs = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs["result"], "�û���¼ʧ��!")
      @uid = rs["uid"]
    }

    operate("3����ȡ¼���豸device_id�ţ�") {
      rs= @iam_obj.add_device(@tc_devname, @tc_devmac1, @uid)
      assert_equal(@ts_add_rs, rs["result"], "����豸ʧ��!")
    }

    operate("4��ɾ���豸��") {
      rs=@iam_obj.qd_dev(@tc_devname, @uid)
      assert_equal(@ts_add_rs, rs["result"], "ɾ���豸ʧ��!")
      assert_equal(@ts_delete_msg, rs["msg"], "ɾ���豸ʧ��!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
       @iam_obj.usr_delete_device(@tc_devname, @tc_usr_phone, @tc_usr_pw)
    }
  end

}
