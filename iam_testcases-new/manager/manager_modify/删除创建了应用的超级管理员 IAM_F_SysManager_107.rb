#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_107", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_account1 = "klwn101@163.com"
    @tc_passwd   = "123456"
    @tc_nickname = "hualaxiang"
    @tc_commnets = "sub manager"
    @tc_app_name = "SubAPPCome"
    @tc_args     ={"name"         => @tc_app_name,
                   "provider"     => "autotest",
                   "redirect_uri" => @ts_app_redirect_uri,
                   "comments"     => "autotest"}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
    }

    operate("3��֪·����Ա��������������Ա��") {
      #������ȷ����Ҫ��������Ա��û��Ӧ��
      rs = @iam_obj.get_mlist_byname(@tc_account1)
      if !rs["res"].empty?&&@tc_account1==rs["res"][0]["name"]
        puts "�����������Ա#{@tc_account1}�Ѿ����ڣ�ɾ����Ӧ��".to_gbk
        @iam_obj.mana_del_app(@tc_app_name, nil, @tc_account1, @tc_passwd)
      else
        puts "֪·����Ա������������Ա#{@tc_account1}".to_gbk
        rs_login = @iam_obj.manager_del_add(@tc_account1, @tc_passwd, @tc_nickname)
        assert_equal(@ts_admin_log_rs, rs_login["result"], "�����˻�#{@tc_account1}ʧ��!")
      end
    }

    operate("4����¼��������Ա��ȡid��tokenֵ") {
    }

    operate("5����������Ա������һ��Ӧ�ã�") {
      rs_app = @iam_obj.mana_create_app(@tc_args, @tc_account1, @tc_passwd)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "����һ��Ӧ��ʧ��!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "����һ��Ӧ��ʧ��!")
    }

    operate("6��֪·����Ա��ɾ���Ѵ����ĳ�������Ա������uidΪ��¼����ԱID��useridΪ��ɾ������ԱID��tokenֵΪ��¼����Աtokenֵ��") {
      rs = @iam_obj.del_manager(@tc_account1)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_manappex_code, rs["err_code"], "����Ӧ�õĹ���ɾ��ʱ����code����!")
      assert_equal(@ts_err_manappex_msg, rs["err_msg"], "����Ӧ�õĹ���ɾ��ʱ����msg����!")
      assert_equal(@ts_err_manappex_desc, rs["err_desc"], "����Ӧ�õĹ���ɾ��ʱ����desc����!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      rs = @iam_obj.get_mlist_byname(@tc_account1)
      if @tc_account1==rs["res"][0]["name"]
        @iam_obj.mana_del_app(@tc_app_name, nil, @tc_account1, @tc_passwd)
        @iam_obj.del_manager(@tc_account1)
      else
        @iam_obj.del_manager(@tc_account1)
      end
    }
  end

}
