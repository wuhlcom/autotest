#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_035", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_args        = []
    @tc_provider    = "zhilutec"
    @tc_comments    = "autotest"
    @tc_app_name1   = "ɽë��"
    param_part      = {provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args1       = {name: @tc_app_name1, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_new_appnames= ["~#%^*()_+{}:\"|<>?-=[];'\\,./", "������������"]
    @tc_new_appnames.each do |appname|
      param_name = {name: appname}
      args       = param_part.merge(param_name)
      @tc_args<<args
    end

  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("3����ȡ�޸�Ӧ�õ�Ӧ��ID��;") {
      puts "����Ӧ����Ϊ'#{@tc_app_name1}'".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "����һ��Ӧ��ʧ��!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "����һ��Ӧ��ʧ��!")
    }

    operate("4���޸�Ӧ�������쳣���룻") {
      @tc_args.each_with_index do |args, index|
        appname = args[:name]
        tip     = "Ӧ������'#{@tc_app_name1}'======>�޸�Ϊ'#{appname}'"
        puts tip.to_gbk
        rs_app= @iam_obj.mod_app(@tc_app_name1, @token, @admin_id, args)
        puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
        puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
        puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
        assert_equal(@ts_err_appformat_msg, rs_app["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
        assert_equal(@ts_err_appformat_code, rs_app["err_code"], "#{tip}���ش���code����ȷ!")
        assert_equal(@ts_err_appformat_desc, rs_app["err_desc"], "#{tip}���ش���desc����ȷ!")
      end
    }

  end

  def clearup

    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_app_name1)
    }

  end

}
