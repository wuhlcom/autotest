#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_009", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_app_name1 = "SameAPP"
    @tc_args1     ={"name"         => @tc_app_name1,
                    "provider"     => "autotest",
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_args2     ={"name"         => @tc_app_name1,
                    "provider"     => "autotest2",
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest2"}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("3������Ӧ�ã���������#{@tc_app_name1}��") {
      tip = "������Ӧ����#{@tc_app_name1}"
      puts "#{tip}".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "����һ��Ӧ��ʧ��!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "����һ��Ӧ��ʧ��!")
    }

    operate("4���ٴδ���Ӧ�ã�����{@tc_app_name1}��") {
      tip = "�ظ�������Ӧ��#{@tc_app_name1}"
      puts "#{tip}".to_gbk
      rs_app = @iam_obj.mana_create_app(@tc_args2)
      puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_appexists_msg, rs_app["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_appexists_code, rs_app["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_appexists_desc, rs_app["err_desc"], "#{tip}���ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
