#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_062", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_appname = "wuhl_3452"
    @tc_args    = {name: @tc_appname, provider: "provider", redirect_uri: @ts_app_redirect_uri, comments: "autotest"}
    @tc_cond1   = "wuhl"
    @tc_cond2   = "3452"
    @tc_cond3   = "hl_34"
    @tc_conds   = [@tc_cond1, @tc_cond2, @tc_cond3]
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
      assert_equal(@ts_add_rs, rs["result"], "��Ӧ������ģ����ѯʧ�ܣ�δ��ѯ�����ݣ�")
    }

    operate("3����Ӧ������ģ����ѯ;") {
      @tc_conds.each do |cond|
        args = {"type" => "name", "cond" => cond}
        rs   = @iam_obj.get_app_list(@admin_token, @admin_id, args)
        refute_empty(rs["apps"], "��Ӧ������ģ����ѯʧ�ܣ�δ��ѯ�����ݣ�")
        assert_equal(rs["apps"][0]["name"], @tc_appname, "��Ӧ������ģ����ѯʧ�ܣ�δ��ѯ�����ݣ�")
      end
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_appname)
    }
  end

}
