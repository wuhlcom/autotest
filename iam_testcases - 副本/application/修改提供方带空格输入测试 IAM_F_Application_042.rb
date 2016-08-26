#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_042", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_args      =[]
    @tc_provider  = "zhilutec"
    @tc_comments  = "autotest"
    @tc_app_name1 = "��ɽѩ��"
    @tc_app_pro   = "��ɽ ѩ��"
    param_part    = {name: @tc_app_name1, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args1     ={name: @tc_app_name1, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args2     ={name: @tc_app_name1, provider: @tc_app_pro, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}

    @tc_args<<@tc_args1
    @tc_new_pros= [" ڤ�½�", "��ħ�� "]
    @tc_new_pros.each do |appname|
      param_pro = {provider: appname}
      args      = param_part.merge(param_pro)
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

    operate("3����ȡ�޸�Ӧ�õ�ID��;") {
      puts "����Ӧ����Ϊ'#{@tc_app_name1}'".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "����һ��Ӧ��ʧ��!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "����һ��Ӧ��ʧ��!")
    }

    operate("4���޸�provider����ֵ���ո񣻣��м���ո񡢺����Ҵ��ո�") {
      @tc_args.each_with_index do |args, index|
        next if index==0
        provider = @tc_args[index-1][:provider]
        tip      = "Ӧ���ṩ����'#{provider}'======>�޸�Ϊ'#{args[:provider]}'"
        puts tip.to_gbk
        rs = @iam_obj.mod_app(@tc_app_name1, @token, @admin_id, args)
        assert_equal(@ts_admin_log_rs, rs["result"], "#{tip}ʧ��!")
        assert_equal(@ts_msg_ok, rs["msg"], "#{tip}ʧ��!")
      end
      tc_pro = @tc_args[2][:provider]
      tip    = "Ӧ���ṩ����'#{tc_pro}'======>�޸�Ϊ'#{@tc_app_pro}'"
      puts tip.to_gbk
      rs_app= @iam_obj.mod_app(@tc_app_name1, @token, @admin_id, @tc_args2)
      puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_apppro_msg, rs_app["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_apppro_code, rs_app["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_apppro_desc, rs_app["err_desc"], "#{tip}���ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
