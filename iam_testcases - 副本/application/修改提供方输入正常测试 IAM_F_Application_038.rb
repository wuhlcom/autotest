#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_038", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_args      =[]
    @tc_provider  = "zhilutec"
    @tc_comments  = "autotest"
    @tc_app_name1 = "������"
    param_part    = {name: @tc_app_name1, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args1     = {name: @tc_app_name1, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args<<@tc_args1

    @tc_new_pro = "������niwotah"*3+"ai"
    @tc_new_pros= ["x", @tc_new_pro, "ħ����_01ABc"]
    @tc_new_pros.each do |provider|
      param_pro = {provider: provider}
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

    operate("4���޸�providerΪ����ֵ��") {
      @tc_args.each_with_index do |args, index|
        next if index==0
        pro_name = @tc_args[index-1][:provider]
        new_pro  = args[:provider]
        tip      = "Ӧ���ṩ����'#{pro_name}'======>�޸�Ϊ'#{new_pro}'"
        puts tip.to_gbk
        puts "��Ӧ���ṩ������Ϊ#{new_pro.size}".to_gbk
        rs = @iam_obj.mod_app(pro_name, @token, @admin_id, args)
        assert_equal(@ts_admin_log_rs, rs["result"], "#{tip}ʧ��!")
        assert_equal(@ts_msg_ok, rs["msg"], "#{tip}ʧ��!")
      end
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
