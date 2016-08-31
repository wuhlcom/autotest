#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_ApplicationCenter_017", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13734044444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}

    @tc_app_name1    = "whlapp1"
    @tc_app_name2    = "whlapp2"
    @tc_app_name3    = "whlapp3"
    @tc_app_name4    = "whlapp4"
    @tc_app_provider = "zhilutest"
    @tc_app_comments = "whl"
    @tc_app_name_arr = [@tc_app_name2, @tc_app_name3, @tc_app_name4]

    @tc_app_names =@tc_app_name_arr.unshift(@tc_app_name1)
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

      rs2    = @iam_obj.manager_login()
      @uid   = rs2["uid"]
      @token = rs2["token"]

      @tc_app_infos.each do |app|
        tip ="����Ӧ��'#{app[:name]}'"
        rs3 = @iam_obj.qc_app(app[:name], @token, @uid, app, "1")
        assert_equal(1, rs3["result"], "#{tip}ʧ��")
      end
    }

    operate("2����ȡӦ�õ�ID�ţ�") {
      @rss1 = @iam_obj.usr_qb_app(@tc_phone_usr, @tc_usr_pw, @tc_app_name1)
      assert_equal(1, @rss1["result"], "�û���Ӧ��1ʧ��")

      @rs = @iam_obj.usr_qb_app(@tc_phone_usr, @tc_usr_pw, @tc_app_name_arr)
      assert_equal(1, @rs["result"], "�û�������Ӧ��ʧ��")
    }

    operate("3����ȡ��¼�û���tokenֵ��id�ţ�") {
    }

    operate("4���û���Ӧ�ã�") {
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_names)
    }
  end

}
