#
# description:
# ��ͷ�пո���Զ�ȥ��
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_008", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_app_name1 = " AppOne"
    @tc_args1     ={"name"         => @tc_app_name1,
                    "provider"     => "autotest",
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_app_name2 = "AppTwo "
    @tc_args2     ={"name"         => @tc_app_name2,
                    "provider"     => "autotest",
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_app_name3 = "App Three"
    @tc_args3     ={"name"         => @tc_app_name3,
                    "provider"     => "autotest",
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

    operate("3������Ӧ�ã��������ƴ��ո����룻") {
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
      assert_equal(@ts_err_appformat_msg, rs_app["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_appformat_code, rs_app["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_appformat_desc, rs_app["err_desc"], "#{tip}���ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
      @tc_args.each do |args|
        puts "ɾ��Ӧ��'#{args["name"]}'".to_gbk
        @iam_obj.del_apply(args["name"], @token, @admin_id)
      end
    }
  end

}
