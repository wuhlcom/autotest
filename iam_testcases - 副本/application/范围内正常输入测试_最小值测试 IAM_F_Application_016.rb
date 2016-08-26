#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_016", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_app_name1   = "�����տ�"
    @tc_app_prov1   = "��˹�"
    @tc_app_comment = "1"
    @tc_args1       ={"name"         => @tc_app_name1,
                      "provider"     => @tc_app_prov1,
                      "redirect_uri" => @ts_app_redirect_uri,
                      "comments"     => @tc_app_comment}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
    }

    operate("3������Ӧ�ã�comments����һ���ַ���") {
      tip = "������Ӧ����'#{@tc_app_name1}'��Ӧ�ü�����ݴ�СΪ#{@tc_app_comment.size}"
      puts "#{tip}".to_gbk
      rs_app = @iam_obj.mana_create_app(@tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "����һ��Ӧ��ʧ��!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "����һ��Ӧ��ʧ��!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      puts "ɾ��Ӧ��'#{@tc_args1["name"]}'".to_gbk
      @iam_obj.mana_del_app(@tc_args1["name"])
    }
  end

}
