#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_026", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_app_name1        = "������"
    @tc_app_redirect_url = "http://WWW.QQ.COM"
    @tc_args1            ={"name"         => @tc_app_name1,
                           "provider"     => "autotest",
                           "redirect_uri" => @tc_app_redirect_url,
                           "comments"     => "autotest"}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
    }

    operate("3������Ӧ�ã�redirect_uri�����д��") {
      rs_app = @iam_obj.mana_create_app(@tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "����һ��Ӧ��ʧ��!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "����һ��Ӧ��ʧ��!")
    }

  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
