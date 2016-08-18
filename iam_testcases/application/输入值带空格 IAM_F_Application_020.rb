#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_020", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_app_name1    = "��Դ����"
    @tc_app_pro      = "����֪·IDC"
    @tc_app_comment1 = " PowerManager"
    @tc_args1        ={"name"         => @tc_app_name1,
                       "provider"     => @tc_app_pro,
                       "redirect_uri" => @ts_app_redirect_uri,
                       "comments"     => @tc_app_comment1}
    @tc_app_name2    = "�¶ȿ���"
    @tc_app_comment2 = "TemperatureControl "
    @tc_args2        ={"name"         => @tc_app_name2,
                       "provider"     => @tc_app_pro,
                       "redirect_uri" => @ts_app_redirect_uri,
                       "comments"     => @tc_app_comment2}
    @tc_app_name3    = "�¶ȿ���"
    @tc_app_comment3 = "Humidity Control"
    @tc_args3        ={"name"         => @tc_app_name3,
                       "provider"     => @tc_app_pro,
                       "redirect_uri" => @ts_app_redirect_uri,
                       "comments"     => @tc_app_comment3}
    @tc_args         =[@tc_args1, @tc_args2, @tc_args3]
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("3������Ӧ�ã�comments������ո�") {
      @tc_args.each do |args|
        tip = "����Ӧ����Ϊ'#{args["name"]}',���Ϊ'#{args["comments"]}'"
        puts "#{tip}".to_gbk
        rs_app= @iam_obj.create_apply(@admin_id, @token, args)
        assert_equal(@ts_admin_log_rs, rs_app["result"], "#{tip}ʧ��!")
        assert_equal(@ts_msg_ok, rs_app["msg"], "#{tip}ʧ��!")
      end
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
