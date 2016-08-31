#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_ApplicationCenter_005", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13700114444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}

    @tc_app_name1    = "whl_app1"
    @tc_app_name2    = "whl_app2"
    @tc_app_name3    = "whl_app3"
    @tc_app_name4    = "whl_app4"
    @tc_app_provider = "zhilutest"
    @tc_app_comments = "whl"

    @tc_app_names =[@tc_app_name1, @tc_app_name2, @tc_app_name3, @tc_app_name4].sort
    @tc_app_part  ={provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}
    @tc_app_infos = []
    @tc_app_names.each do |appname|
      args1 = {name: appname}
      args  = args1.merge(@tc_app_part)
      @tc_app_infos<<args
    end
  end

  def process

    operate("1��ssh��¼IAM��������") {

    }

    operate("2����ȡ��¼�û���tokenֵ��id�ţ�") {
      rs1= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs1["result"], "�û�#{@tc_phone_usr}ע��ʧ��")

      #����Ա��¼
      rs2    = @iam_obj.manager_login
      @uid   = rs2["uid"]
      @token = rs2["token"]

      #����Ա����Ӧ��
      @tc_app_infos.each do |app|
        tip ="����Ӧ��'#{app[:name]}'"
        puts tip.to_gbk
        rs3 = @iam_obj.qc_app(app[:name], @token, @uid, app, "1")
        assert_equal(1, rs3["result"], "#{tip}ʧ��")
      end

      #�û���ѯӦ��
      app_name_arr = []
      rs3          = @iam_obj.usr_login_list_app_all(@tc_phone_usr, @tc_usr_pw)
      rs3["apps"].each do |item|
        app_name_arr << item["name"]
      end
      app_name_arr.sort!
      flag= false
      @tc_app_names.each do |appname|
        tip2 ="�û���ѯӦ��'#{appname}'"
        puts tip2.to_gbk
        flag = app_name_arr.include?(appname)
        assert(flag, "#{tip2}ʧ��")
      end
    }

    operate("3���û���ѯ���󶨵�Ӧ���б�") {
      #����Ա����Ӧ��
      @tc_app_names.each do |appname|
        tip1 ="����Ա����Ӧ��'#{appname}'"
        puts tip1.to_gbk
        rs1 = @iam_obj.get_client_active_app(appname, @token, @uid, 0)
        assert_equal(1, rs1["result"], "#{tip1}ʧ��")
      end

      #�û���ѯӦ��
      app_name_arr1 = []
      rs2           = @iam_obj.usr_login_list_app_all(@tc_phone_usr, @tc_usr_pw)
      rs2["apps"].each do |item|
        app_name_arr1 << item["name"]
      end
      app_name_arr1.sort!

      flag= false
      @tc_app_names.each do |appname|
        tip2 ="����Ա����Ӧ��'#{appname}'���û���ѯӦ��'#{appname}'"
        puts tip2.to_gbk
        flag = app_name_arr1.include?(appname)
        refute(flag, "#{tip2}ʧ��")
      end

      #����Ա����Ӧ��
      @tc_app_names.each do |appname|
        tip3 ="����Ա��������Ӧ��'#{appname}'"
        puts tip3.to_gbk
        rs3 = @iam_obj.get_client_active_app(appname, @token, @uid, 1)
        assert_equal(1, rs3["result"], "#{tip3}ʧ��")
      end

      #�û���ѯӦ��
      app_name_arr = []
      rs4          = @iam_obj.usr_login_list_app_all(@tc_phone_usr, @tc_usr_pw)
      rs4["apps"].each do |item|
        app_name_arr << item["name"]
      end
      app_name_arr.sort!

      flag= false
      @tc_app_names.each do |appname|
        tip4="����Ա��������Ӧ��'#{appname}'���û���ѯӦ��'#{appname}'"
        puts tip4.to_gbk
        flag = app_name_arr.include?(appname)
        assert(flag, "#{tip4}ʧ��")
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
