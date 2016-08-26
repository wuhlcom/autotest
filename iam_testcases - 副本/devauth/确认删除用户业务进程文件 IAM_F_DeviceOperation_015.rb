#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_015", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_app_name  = "IAM_F_DeviceOperation_015"
    @tc_file_mode = "2" #̽��
    @tc_comm      = "IAMAPI_TEST�Զ�������ר��"
    @tc_app_args  ={name: @tc_app_name, provider: @tc_comm, redirect_uri: @ts_app_redirect_uri, comments: @tc_comm}
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs           = @iam_obj.manager_login #����Ա��¼->�õ�uid��token
      @admin_uid   =rs["uid"]
      @admin_token =rs["token"]
      puts "����Ӧ����Ϊ'#{@tc_app_name}'".to_gbk
      rs_app=@iam_obj.qc_app(@tc_app_name, @admin_token, @admin_uid, @tc_app_args, "1") #����Ӧ�ò�����
      assert_equal(@ts_admin_log_rs, rs_app["result"], "����һ��Ӧ��ʧ��!")
      file = "�ϴ�Ӧ�ý����ļ�'#{@ts_file_so1}'"
      puts file.to_gbk
      loginobj = IamPageObject::FucList.new(@browser)
      loginobj.login(@ts_admin_usr, @ts_admin_pw, @ts_admin_login, @ts_admin_code)
      loginobj.set_app_file(@tc_app_name, @ts_file_so1)
    }

    operate("2����ȡӦ���б���Ӧ��id�ţ���") {
      rs = @iam_obj.mana_get_app_files(@tc_app_name) #�˴������ô˽ӿ������»�ȡadmin-id��admin-token
      refute_empty(rs, "��ѯӦ��ҵ������ļ�Ϊ��!")
      file_name   = rs[0]["file_name"]
      file_module = rs[0]["file_module"]
      assert_equal(@ts_so1, file_name, "��ѯӦ��ҵ������ļ�ʧ��!")
      assert_equal(@tc_file_mode, file_module, "��ѯӦ��ҵ������ļ�ʧ��!")
    }

    operate("3��ɾ��ĳ��ҵ������ļ���") {
      rs_del=@iam_obj.mana_del_app_file(@tc_app_name, @ts_so1)
      assert_equal(@ts_add_rs, rs_del["result"], "ɾ��Ӧ��ҵ������ļ�ʧ��!")
      assert_equal(@ts_msg_ok, rs_del["msg"], "ɾ��Ӧ��ҵ������ļ�ʧ��!")

      rs = @iam_obj.mana_get_app_files(@tc_app_name) #�˴������ô˽ӿ������»�ȡadmin-id��admin-token
      assert_empty(rs, "Ӧ��ҵ������ļ�δɾ��!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_app_name)
    }
  end

}
