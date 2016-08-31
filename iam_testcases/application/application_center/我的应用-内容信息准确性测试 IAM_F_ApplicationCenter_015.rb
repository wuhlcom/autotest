#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_ApplicationCenter_015", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_phone_usr    = "13744144444"
    @tc_usr_pw       = "123456"
    @tc_usr_regargs  = {type: "account", cond: @tc_phone_usr}

    @tc_app_name1    = "whlap1"
    @tc_app_provider = "whlpri"
    @tc_app_comments = "whl"
    @tc_app_args     ={name: @tc_app_name1, provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")

      @rs1  = @iam_obj.qca_app(@tc_app_name1, @tc_app_args, "1")
      assert_equal(1, @rs1["result"], "����Ӧ��1ʧ��")
    }

    operate("2����ȡ��¼�û���tokenֵ��id�ţ�") {
    }

    operate("3���û���ѯ���󶨵�Ӧ���б�") {
      rs = @iam_obj.usr_login_list_app_all(@tc_phone_usr, @tc_usr_pw)
      assert_equal(@tc_app_name1, rs["apps"][0]["name"], "��ѯ���󶨵�Ӧ���б�ʧ��")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
