#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_OAuth_026", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_app_name1   = "GoToTheShop"
    @tc_app_prov1   = "��������ũ��"
    @tc_app_comment = "��������ũ���Ļ���"
    @tc_args1       = {name: @tc_app_name1, provider: @tc_app_prov1, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comment}
    @tc_app_status  = "1"
    @tc_phone       = "13103188889"
    @tc_pw          = "zhilutec123"
    @tc_err_appid   = "16000000"
  end

  def process

    operate("1��ssh��¼��IAM��������") {
    }
    operate("2������Ա����Ӧ��") {
      tip = "����Ա��¼"
      puts "#{tip}".to_gbk
      rs_login = @iam_obj.manager_login
      assert_equal(@ts_admin_log_rs, rs_login["result"], "#{tip}ʧ��!")

      @mana_uid   = rs_login["uid"]
      @mana_token = rs_login["token"]

      step = "����Ա����������Ӧ��"
      puts "#{step}".to_gbk
      rs =@iam_obj.qc_app(@tc_app_name1, @mana_token, @mana_uid, @tc_args1, @tc_app_status)
      assert_equal(@ts_admin_log_rs, rs["result"], "#{step}ʧ��!")
      assert_equal(@ts_modify_msg, rs["msg"], "#{step}ʧ��!")

      step1 = "����Ա��ѯӦ��'#{@tc_app_name1}'��Ϣ"
      puts "#{step1}".to_gbk
      rs_app = @iam_obj.get_spec_app_info(@mana_token, @tc_app_name1, @mana_uid)
      assert_equal(@tc_app_name1, rs_app["name"], "#{step1}ʧ��!")
      @app_id    = rs_app["client_id"]
      @app_secret= rs_app["client_secret"]
    }

    operate("3���û�ע��") {
      args     = {"type" => "account", "cond" => @tc_phone}
      rs_users = @iam_obj.get_user_list(@mana_uid, @mana_token, args)
      if rs_users["users"].empty?||rs_users["users"][0]["account"]==@tc_phone
        @iam_obj.register_phoneusr(@tc_phone, @tc_pw)
      end
    }

    operate("4���û���¼����Ӧ��") {
      step1 = "�û�'#{@tc_phone}'��¼"
      puts "#{step1}".to_gbk
      rs_usr =@iam_obj.user_login(@tc_phone, @tc_pw)
      assert_equal(@ts_admin_log_rs, rs_usr["result"], "#{step1}ʧ��!")
      assert_equal(@tc_phone, rs_usr["account"], "#{step1}ʧ��!")

      usrid =rs_usr["uid"]
      token =rs_usr["access_token"]

      step2 = "�û�'#{@tc_phone}'��¼���ѯӦ��"
      puts "#{step2}".to_gbk
      rs      = @iam_obj.user_app_list_bytype(@tc_app_name1, usrid, token, true)
      appname = rs["apps"][0]["name"]
      assert_equal(@tc_app_name1, appname, "#{step2}ʧ��!")

      data  ={"client_id" => rs["apps"][0]["client_id"]}
      step3 = "�û�'#{@tc_phone}'��¼���Ӧ��"
      puts "#{step3}".to_gbk
      rs_bind = @iam_obj.usr_binding_app(token, usrid, data)
      assert_equal(@ts_admin_log_rs, rs_bind["result"], "#{step3}ʧ��!")
      assert_equal(@ts_msg_ok, rs_bind["msg"], "#{step3}ʧ��!")
    }

    operate("5���û�oauth��¼,��ȡ�û�userid��") {
      tip     = "�û�'#{@tc_phone}'oauth��¼"
      @userid = @iam_obj.usr_oauth_usrid(@tc_phone, @tc_pw, @app_secret, @app_id)
      usrid   = @iam_obj.get_userid
      assert_equal(usrid, @userid, "#{tip}ʧ��!")
    }

    operate("6��client_id�������") {
      tip = "client_id�������"
      rs  = @iam_obj.usr_oauth_code(@userid, @tc_err_appid, @app_secret)
      puts "RESULT err_msg:'#{rs['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_oauthtoken_msg, rs["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_oauthtoken_code, rs["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_oauthtoken_desc, rs["err_desc"], "#{tip}���ش���desc����ȷ!")
    }

  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      operate("1.�û������") {
        @iam_obj.usr_qub_app(@tc_phone, @tc_pw, @tc_app_name1, true)
      }

      operate("2.ɾ��Ӧ��") {
        @iam_obj.mana_del_app(@tc_app_name1)
      }

    }
  end

}
