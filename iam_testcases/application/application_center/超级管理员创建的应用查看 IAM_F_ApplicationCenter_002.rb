#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_ApplicationCenter_002", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_app_name1    = "autotest_app1"
    @tc_app_name2    = "autotest_app2"
    @tc_app_provider = "zhilutest"
    @tc_app_comments = ""
    @tc_app_names    = [@tc_app_name1, @tc_app_name2]

    @tc_usr_part = {provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}
    @tc_usr_args = []
    @tc_app_names.each do |tc_usr_name|
      args = {name: tc_usr_name}
      args = args.merge(@tc_usr_part)
      @tc_usr_args<<args
    end
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@ts_phone_usr}ע��ʧ��")
    }

    operate("2����ȡ��¼�û���tokenֵ��id�ţ�") {
      rs    = @iam_obj.manager_login()
      uid   = rs["uid"]
      token = rs["token"]
      @tc_usr_args.each do |args|
        rs2= @iam_obj.qc_app(args[:name], token, uid, args, "1")
        assert_equal(@ts_add_rs, rs2["result"], "����Ӧ��#{args["name"]}������ʧ��")
      end
    }

    operate("3���û���ѯ���󶨵�Ӧ���б�") {
      app_name_arr = []
      flag         = false
      rs           = @iam_obj.usr_login_list_app_all(@ts_phone_usr, @ts_usr_pw)
      rs["apps"].each do |item|
        app_name_arr << item["name"]
      end
      flag = true if app_name_arr.include?(@tc_app_name1) && app_name_arr.include?(@tc_app_name2)
      assert(flag, "�û�δ��ѯ���Ѽ����Ӧ��")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_app_name1)
      @iam_obj.mana_del_app(@tc_app_name2)
      @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
    }
  end

}
