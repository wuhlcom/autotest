#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_044", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_appname      = "whlmodify009"
    @tc_provider     = "whl"
    @tc_comments     = "whlmodify"
    @tc_args         = {name: @tc_appname, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_app_comments = "0"
  end

  def process

    operate("1��ssh��¼IAM��������") {
      @res = @iam_obj.manager_login #����Ա��¼->�õ�uid��token
      assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
      @admin_id    = @res["uid"]
      @admin_token = @res["token"]
      rs           = @iam_obj.qc_app(@tc_appname, @admin_token, @admin_id, @tc_args)
      assert_equal(@ts_add_rs, rs["result"], "����Ӧ��ʧ��!")
    }

    operate("3����ȡ�޸�Ӧ�õ�Ӧ��ID��;") {
      @client_id = @iam_obj.get_client_id(@tc_appname, @admin_token, @admin_id)
    }

    operate("4���޸�commentsΪһ���ַ���") {
      args = {name: @tc_appname, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}
      @rs  = @iam_obj.modify_apply(@admin_id, @admin_token, @client_id, args)
      assert_equal(1, @rs["result"], "�޸�commentsΪһ���ַ�ʧ��")

      #����Ƿ��޸ĳɹ�
      rs_detail = @iam_obj.apply_details(@client_id, @admin_id, @admin_token)
      assert_equal(@tc_app_comments, rs_detail["comments"], "�޸�comments�����ѯδ�޸ĳɹ���")
    }

  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_appname)
    }
  end

}
