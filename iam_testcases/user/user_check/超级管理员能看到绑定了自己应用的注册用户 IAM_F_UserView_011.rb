#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_UserView_011", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13704424444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}

    @tc_superapp_usr = "autotest_super"
    @tc_app_provider = "whl"
    @tc_args         = {name: @tc_superapp_usr, provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: "whl"}
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")

      tip = "����һ����Ӧ��'#{@tc_args[:name]}'"
      puts tip.to_gbk
      rs2= @iam_obj.qca_app(@tc_args[:name], @tc_args, "1")
      assert_equal(1, rs2["result"], "#{tip}ʧ�ܣ�")
    }

    operate("2����ȡ��������Աtokenֵ��") {
      rs_bind = @iam_obj.usr_qb_app(@tc_phone_usr, @tc_usr_pw, @tc_args[:name])
      assert_equal(1, rs_bind["result"], "�û���Ӧ��ʧ��")
    }

    operate("3����ȡ�����û��б�") {
      res          = @iam_obj.manager_login
      @admin_id    = res["uid"]
      @admin_token = res["token"]
      rs           = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
      uid          = rs["uid"]
      rs           = @iam_obj.get_user_details(@admin_id, @admin_token, uid)
      refute_empty(rs["apps"], "�����û�Ӧ����Ϣʧ��")
      assert_equal(rs["apps"].include?(@tc_args[:name]), "��ȡ����Ӧ�õ��û�ʧ��")
    }

  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_args[:name])
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
    }
  end

}
