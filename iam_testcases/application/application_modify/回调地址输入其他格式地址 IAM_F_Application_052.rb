#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_052", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_appname          = "whlmodify006"
    @tc_provider         = "whl"
    @tc_comments         = "whlmodify"
    @tc_args             = {name: @tc_appname, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_app_redirect_uri = "ftp://58.250.160.236:8281/o2o-video/web/parking/getAccessToken"

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
      assert_equal(@ts_add_rs, rs["result"], "����Ӧ��ʧ��!")
    }

    operate("3����ȡ�޸�Ӧ�õ�Ӧ��ID��;") {
      @client_id = @iam_obj.get_client_id(@tc_appname, @admin_token, @admin_id)
    }

    operate("4���޸�redirect_uri��ַ����������ʽ��") {
      tip  ="�޸�redirect_uri��ַ����������ʽ"
      args = {name: @tc_appname, provider: @tc_provider, redirect_uri: @tc_app_redirect_uri, comments: @tc_comments}
      rs   = @iam_obj.modify_apply(@admin_id, @admin_token, @client_id, args)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_appurl_code, rs["err_code"], "#{tip}����code����!")
      assert_equal(@ts_err_appurl_msg, rs["err_msg"], "#{tip}����msg����")
      assert_equal(@ts_err_appurl_desc, rs["err_desc"], "#{tip}����desc����!")
    }
  end

  def clearup

    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_appname)
    }
  end

}
