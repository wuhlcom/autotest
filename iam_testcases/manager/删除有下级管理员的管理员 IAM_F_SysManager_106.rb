#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_106", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_account1 = "klwn201@163.com"
    @tc_account2 = "klwn202@163.com"
    @tc_passwd   = "123456"
    @tc_nickname = "pilipala"
    @tc_commnets = "sub manager"
    @tc_rcode    = "3"
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����tokenֵ��") {
    }

    operate("3��֪·����Ա��������������Ա��") {
      #�����˻�
      puts "֪·����Ա������������Ա#{@tc_account1}".to_gbk
      rs_login = @iam_obj.manager_del_add(@tc_account1, @tc_passwd, @tc_nickname)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "�����˻�#{@tc_account1}ʧ��!")
    }

    operate("4����������Ա������ϵͳ����Ա��") {
      puts "��������Ա#{@tc_account1}����ϵͳ����Ա#{@tc_account2}".to_gbk
      rs= @iam_obj.manager_del_add(@tc_account2, @tc_passwd, @tc_nickname, @tc_rcode, @tc_commnets, @tc_account1, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "��������Ա#{@tc_account1}����ϵͳ����Ա#{@tc_account2}ʧ��!")
      assert_equal(@ts_add_msg, rs["msg"], "��������Ա#{@tc_account1}����ϵͳ����Ա#{@tc_account2}ʧ��!")
    }

    operate("5��֪·����Ա�»�ȡ����Ա�б�͹���Աuerid�ţ�") {
    }

    operate("6��ɾ��ָ���Ĺ���Ա��") {
      rs= @iam_obj.del_manager(@tc_account1)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal( @ts_err_manadel_code, rs["err_code"], "ɾ�������¼�����Ա�Ĺ���Ա����err_code����!")
      assert_equal( @ts_err_manadel_msg, rs["err_msg"], "ɾ�������¼�����Ա�Ĺ���Ա����err_msg����!")
      assert_equal( @ts_err_manadel_desc, rs["err_desc"], "ɾ�������¼�����Ա�Ĺ���Ա����err_desc����!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_account2, @tc_account1, @tc_passwd)
      @iam_obj.del_manager(@tc_account1)
    }
  end

}
