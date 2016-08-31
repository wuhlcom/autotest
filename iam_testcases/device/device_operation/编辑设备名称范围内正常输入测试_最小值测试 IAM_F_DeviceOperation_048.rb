#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_048", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_dev_name2 = "autotest_dev2"
    @tc_dev_mac2  = "00:1a:31:00:01:78"
    @name_editor2 = "0"
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@ts_phone_usr}ע��ʧ��")
    }

    operate("2����ȡ��¼�û�uid�ţ�") {
      @rs2 = @iam_obj.usr_add_devices(@tc_dev_name2, @tc_dev_mac2, @ts_phone_usr, @ts_usr_pw)
      assert_equal(1, @rs2["result"], "�û�2�����豸ʧ��")
    }

    operate("3����ȡ¼���豸A��device_id�ţ�") {
    }

    operate("4���༭�豸A���Ƶ����ַ���") {
      @rss2 = @iam_obj.usr_device_editor(@ts_phone_usr, @ts_usr_pw, @tc_dev_name2, @name_editor2)
      assert_equal(1, @rss2["result"], "�޸��豸����ʧ��")
    }

  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
    }
  end

}
