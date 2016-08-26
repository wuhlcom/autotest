#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_047", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname   = "Mydevice"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
    @tc_devmac1   = "00:88:00:00:00:01"
    @tc_app_name  = "zhilutecApp"
    @tc_args      = {name: @tc_app_name, provider: "autotest", redirect_uri: @ts_app_redirect_uri, comments: "autotest"}
  end

  def process

    operate("1��ssh��¼IAM��������") {
      @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args) #�û�ע��
      rs        = @iam_obj.manager_login #����Ա��¼
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("2����ȡ��¼�û�uid�ţ�") {
      @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args) #�û�ע��
      rs        = @iam_obj.manager_login #����Ա��¼
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("3����ȡ¼���豸A��device_id�ţ�") {
      puts "����Ӧ����Ϊ'#{@tc_app_name}'".to_gbk
      rs_app=@iam_obj.qc_app(@tc_app_name, @token, @admin_id, @tc_args, "1") #����Ӧ�ò�����
      assert_equal(@ts_admin_log_rs, rs_app["result"], "����һ��Ӧ��ʧ��!")
      tip = "��ȡӦ��ID"
      puts tip.to_gbk
      rs_client_id = @iam_obj.get_client_id(@tc_app_name, @token, @admin_id)

      #�û���¼
      rs_login     = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs_login["result"], "�û���¼ʧ��!")
      @uid = rs_login["uid"]
      #����豸
      op1  = "����豸"
      puts op1.to_gbk
      rs_add = @iam_obj.add_device(@tc_devname, @tc_devmac1, @uid)
      assert_equal(@ts_add_rs, rs_add["result"], "#{op1}ʧ��!")

      #�豸��Ӧ��
      appid_arr = [rs_client_id]
      rs_bind   = @iam_obj.qb_dev(@tc_devname, @uid, appid_arr)
      assert_equal(@ts_admin_log_rs, rs_bind["result"], "�豸��Ӧ��ʧ��!")
    }

    operate("4��ɾ���豸A��") {
      rs=@iam_obj.qd_dev(@tc_devname, @uid)
      assert_equal(@ts_add_rs, rs["result"], "ɾ����Ӧ�õ��豸ʧ��!")
      assert_equal(@ts_delete_msg, rs["msg"], "ɾ����Ӧ�õ��豸ʧ��!")
    }

    operate("5���û���������豸A��") {
      rs_add = @iam_obj.add_device(@tc_devname, @tc_devmac1, @uid)
      assert_equal(@ts_add_rs, rs_add["result"], "�û���������豸Aʧ��!")

      rs_app = @iam_obj.dev_binding_apps(@tc_devname, @uid)
      assert_empty(rs_app["relapps"], "��������豸ԭ�󶨹�ϵδ���")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_device(@tc_devname, @tc_usr_phone, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_name)
    }
  end

}
