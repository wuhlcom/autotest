#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_070", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_phone_usr    = "13740044444"
    @tc_usr_pw       = "123456"
    @tc_usr_regargs  = {type: "account", cond: @tc_phone_usr}
    @tc_app_name1    = "wuhlcomapp"
    @tc_app_provider = "wuhl"
    @tc_app_comments = "wuhl"
    @tc_dev_name     = "autotest_dev"
    @tc_dev_mac      = "00:1E:A2:00:01:51"
    @tc_app_args     = {name: @tc_app_name1, provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}
  end

  def process

    operate("1��ssh��¼��IAM��������") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")

      @rs1 = @iam_obj.qca_app(@tc_app_name1, @tc_app_args, "1")
      assert_equal(1, @rs1["result"], "����Ӧ��1������ʧ��")
    }

    operate("2����ѯ������Ȩ��Ӧ���б�") {
      @rs = @iam_obj.usr_add_devices(@tc_dev_name, @tc_dev_mac, @tc_phone_usr, @tc_usr_pw)
      assert_equal(1, @rs["result"], "�û������豸ʧ��")
    }

    operate("3�����豸��Ȩ����Ӧ�ã�") {
      client_id  = @iam_obj.mana_get_client_id(@tc_app_name1)
      client_arr = [client_id]
      rs         = @iam_obj.usr_dev_bindapp(@tc_dev_name, client_arr, @tc_phone_usr, @tc_usr_pw)
      assert_equal(1, rs["result"], "�豸��ȨӦ��ʧ��")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
