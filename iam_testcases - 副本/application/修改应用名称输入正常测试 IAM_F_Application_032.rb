#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_032", "level" => "P1", "auto" => "n"}

  def prepare

    @tc_args      =[]
    @tc_provider  = "wo"
    @tc_comments  = "autotest"
    @tc_app_name1 = "��Ҫ���޸���"
    param_part    = {provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args1     ={name: @tc_app_name1, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}

    @tc_args<<@tc_args1
    @tc_new_appname = "������niwotah"*3+"ai"
    @tc_new_appnames= ["z", @tc_new_appname, "ħ����_01ABc"]
    @tc_new_appnames.each do |appname|
      param_name = {"name": appname}
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
    }

    operate("4���޸�Ӧ�����ƣ�") {
      puts "����Ӧ����Ϊ'#{@tc_app_name1}'".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "����һ��Ӧ��ʧ��!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "����һ��Ӧ��ʧ��!")

      @tc_args.each_with_index do |args, index|
        next if index==0
        appname     = @tc_args[index-1][:name]
        new_appname = args[:name]
        tip         = "Ӧ������'#{appname}'======>�޸�Ϊ'#{new_appname}'"
        puts tip.to_gbk
        puts "��Ӧ��������Ϊ#{new_appname.size}".to_gbk
        rs = @iam_obj.mod_app(appname, @token, @admin_id, args)
        assert_equal(@ts_admin_log_rs, rs["result"], "#{tip}ʧ��!")
        assert_equal(@ts_msg_ok, rs["msg"], "#{tip}ʧ��!")
      end

    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
      @tc_args.each do |args|
        appname = args[:name]
        puts "ɾ��Ӧ��'#{appname}'".to_gbk
        @iam_obj.del_apply(appname, @token, @admin_id)
        # @iam_obj.mana_del_app(appname)
      end
    }
  end

}
