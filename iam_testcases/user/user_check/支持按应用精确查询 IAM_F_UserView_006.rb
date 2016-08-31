#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_UserView_006", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13708114444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}

    @tc_app_name     = "wuhlcapp"
    @tc_app_provider = "whlcom"
    @tc_args         = {name: @tc_app_name, provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: "whl"}
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")

      #����Ա��¼
      rs3        = @iam_obj.manager_login
      @uid       = rs3["uid"]
      @token     = rs3["token"]

      #����Ա����Ӧ��
      tip        ="����Ӧ��'#{@tc_app_name}'"
      puts tip.to_gbk
      rs4 = @iam_obj.qc_app(@tc_app_name, @token, @uid, @tc_args, "1")
      assert_equal(1, rs4["result"], "#{tip}ʧ��")
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
      tip="�û�'#{@tc_phone_usr}'��Ӧ��'#{@tc_app_name}'"
      p tip.encode("GBK")
      rs = @iam_obj.usr_qb_app(@tc_phone_usr, @tc_usr_pw, @tc_app_name)
      assert_equal(1, rs["result"], "#{tip}ʧ��")
    }

    operate("3����Ӧ�þ�ȷ��ѯ��") {
      args = {"type" => "client_name", "cond" => @tc_app_name}
      rs   = @iam_obj.get_user_list(@uid, @token, args)
      assert_equal(@tc_phone_usr, rs["users"][0]["account"], "δ��ѯ�����û�")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_name)
    }
  end

}
