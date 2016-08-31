#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_ApplicationCenter_018", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13700114444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}

    @tc_app_name1    = "wuhlcomapp1"
    @tc_app_name2    = "wuhlcomapp2"
    @tc_app_name3    = "wuhlcomapp3"
    @tc_app_name4    = "wuhlcomapp4"
    @tc_app_provider = "whlcom"
    @tc_app_comments = "whl"

    @tc_app_names =[@tc_app_name1, @tc_app_name2, @tc_app_name3, @tc_app_name4]
    @tc_app_part  ={provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}
    @tc_app_infos = []
    @tc_app_names.each do |appname|
      args1 = {name: appname}
      args  = args1.merge(@tc_app_part)
      @tc_app_infos<<args
    end
  end

  def process

    operate("1��ssh��¼��������") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")

      rs2    = @iam_obj.manager_login
      @uid   = rs2["uid"]
      @token = rs2["token"]

      @tc_app_infos.each do |app|
        tip ="����Ӧ��'#{app[:name]}'"
        rs3 = @iam_obj.qc_app(app[:name], @token, @uid, app, "1")
        assert_equal(1, rs3["result"], "#{tip}ʧ��")
      end
    }

    operate("2����ȡ��¼�û���tokenֵ��id�ţ�") {
      rs_login   = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
      @usr_id    = rs_login["uid"]
      @usr_token = rs_login["access_token"]

      @tc_app_names.each do |appname|
        rs1 = @iam_obj.qb_app(appname, @usr_id, @usr_token)
        assert_equal(1, rs1["result"], "�û���Ӧ��'#{appname}'ʧ��")
      end
    }

    operate("3���û���ѯ�ҵ�Ӧ�ã�") {
    }

    operate("4���û����Ӧ�ð󶨣�") {
      @tc_app_names.each do |appname|
        rs1 = @iam_obj.qub_app(appname, @usr_id, @usr_token)
        assert_equal(1, rs1["result"], "�û���Ӧ��'#{appname}'ʧ��")
      end
    }

  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_names)
    }
  end

}
