#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_ApplicationCenter_019", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13730104444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}

    @tc_app_name1    = "application1"
    @tc_app_provider = "zhilutest"
    @tc_app_comments = "whl"
    @tc_app_args     ={name: @tc_app_name1, provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}
  end

  def process

    operate("1��ssh��¼��������") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")

      @rs1  = @iam_obj.qca_app(@tc_app_name1, @tc_app_args, "1")
      assert_equal(1, @rs1["result"], "����Ӧ��1ʧ��")
    }

    operate("2��֪·����Ա���ø�Ӧ�ã�") {
      rs = @iam_obj.usr_qb_app(@tc_phone_usr, @tc_usr_pw, @tc_app_name1)
      assert_equal(1, rs["result"], "�û���Ӧ��1ʧ��")

      rs3 = @iam_obj.usr_login_list_app_bytype(@tc_phone_usr, @tc_usr_pw, @tc_app_name1, false)
      assert_equal(@tc_app_name1, rs3["apps"][0]["name"], "��Ӧ�ú󣬲����Բ�ѯ��Ӧ��")
    }

    operate("3���û���ѯ�ҵ�Ӧ�ã�") {
      @res = @iam_obj.mana_active_app(@tc_app_name1, "0")
      assert_equal(1, @res["result"], "Ӧ��1����ʧ��")

      rs3 = @iam_obj.usr_login_list_app_bytype(@tc_phone_usr, @tc_usr_pw, @tc_app_name1, false)
      assert_equal("0", rs3["totalRows"], "����Ӧ�ú󣬿��Բ�ѯ��Ӧ��")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
