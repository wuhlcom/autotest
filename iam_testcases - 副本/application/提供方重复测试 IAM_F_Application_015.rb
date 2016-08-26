#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_015", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_app_name1 = "�Զ�����"
    @tc_app_name2 = "�����в�"
    @tc_app_pro   = "������"
    @tc_args1     ={"name"         => @tc_app_name1,
                    "provider"     => @tc_app_pro,
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_args2     ={"name"         => @tc_app_name2,
                    "provider"     => @tc_app_pro,
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

    operate("3������Ӧ�ã�provider����֪·��˾��") {
      tip = "������Ӧ����'#{@tc_app_name1}',Ӧ���ṩ��'#{@tc_app_pro}'"
      puts "#{tip}".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "����һ��Ӧ��ʧ��!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "����һ��Ӧ��ʧ��!")
    }

    operate("4���ٴδ���Ӧ�ã�provider����֪·��˾��") {
      tip = "������Ӧ����'#{@tc_app_name2}',Ӧ���ṩ��'#{@tc_app_pro}'"
      puts "#{tip}".to_gbk
      rs_app = @iam_obj.create_apply(@admin_id, @token, @tc_args2)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "������һ��Ӧ��ʧ��!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "������һ��Ӧ��ʧ��!")
    }

  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_app_name1)
      @iam_obj.mana_del_app(@tc_app_name2)
    }
  end
}
