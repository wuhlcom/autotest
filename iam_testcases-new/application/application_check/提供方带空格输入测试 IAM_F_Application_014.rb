#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_014", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_app_name1 = "���Կ���"
    @tc_app_pro1  = " AppOne"
    @tc_args1     ={"name"         => @tc_app_name1,
                    "provider"     => @tc_app_pro1,
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_app_name2 = "�Զ�����"
    @tc_app_pro2  = "AppTwo "
    @tc_args2     ={"name"         => @tc_app_name2,
                    "provider"     => @tc_app_pro2,
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_app_name3 = "�ѻ�����"
    @tc_app_pro3  = "App Three"
    @tc_args3     ={"name"         => @tc_app_name3,
                    "provider"     => @tc_app_pro3,
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_args      =[@tc_args1, @tc_args2]
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("3������Ӧ�ã�provider������пո��������Ҵ��ڿո��򱣴�ɹ�����") {
      @tc_args.each do |args|
        tip = "����Ӧ����Ϊ'#{args["name"]}"
        puts "#{tip}".to_gbk
        rs_app= @iam_obj.create_apply(@admin_id, @token, args)
        assert_equal(@ts_admin_log_rs, rs_app["result"], "#{tip}ʧ��!")
        assert_equal(@ts_msg_ok, rs_app["msg"], "#{tip}ʧ��!")
      end
      tip   = "����Ӧ����Ϊ'#{@tc_args3["name"]}"
     rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args3)
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
      @tc_args.each do |args|
        puts "ɾ��Ӧ��'#{args["name"]}'".to_gbk
        @iam_obj.mana_del_app(args["name"])
      end
    }
  end

}
