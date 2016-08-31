#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_065", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13700024444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}

    @tc_dev_name = "autotest_dev"
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

    operate("3�����豸���Ʋ�ѯ����ѯ�ֶ�ǰ����пո�") {
      p "��ѯ�ֶ�ǰ���пո�".encode("GBK")
      name = " " + @tc_dev_name
      args = {"type" => "name", "cond" => name}
      rs   = @iam_obj.usr_get_devlist(@tc_phone_usr, @tc_usr_pw, args)
      assert_equal(@tc_dev_name, rs["resList"][0]["device_name"], "��ѯ�ֶ�ǰ���пո񣬰��豸����ѯδ�ܲ�ѯ�����豸")

      p "��ѯ�ֶκ���пո�".encode("GBK")
      name = @tc_dev_name + " "
      args = {"type" => "name", "cond" => name}
      rs1  = @iam_obj.usr_get_devlist(@tc_phone_usr, @tc_usr_pw, args)
      assert_equal(@tc_dev_name, rs1["resList"][0]["device_name"], "��ѯ�ֶκ���пո񣬰��豸����ѯδ�ܲ�ѯ�����豸")
    }

    operate("4�����豸���Ʋ�ѯ����ѯ�ֶ��м���пո������ȫ���ո�") {
      p "��ѯ�ֶ��м���пո�".encode("GBK")
      name = @tc_dev_name.gsub("_", "_ ")
      args = {"type" => "name", "cond" => name}
      rs   = @iam_obj.usr_get_devlist(@tc_phone_usr, @tc_usr_pw, args)
      assert_equal("0", rs["totalRows"], "��ѯ�ֶ��м���пո��ܲ�ѯ�����豸")

      p "��ѯ�������ֱ���������ո�".encode("GBK")
      name = "             "
      args = {"type" => "name", "cond" => name}
      rs   = @iam_obj.usr_get_devlist(@tc_phone_usr, @tc_usr_pw, args)
      refute_equal("0", rs["totalRows"], "��ѯ�������ֱ���������ո�δ��ѯ���豸")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_device(@tc_dev_name, @tc_phone_usr, @tc_usr_pw)
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
    }
  end

}
