#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_140", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_account1   = "shaoe@zhilutec.com"
    @tc_account2   = "kaoya@zhilutec.com"
    @tc_query_str1 = "��������@"
    @tc_passwd     = "123456"
    @tc_nickname1  = "shaoe"
    @tc_nickname2  = "kaoya"
    @tc_commnets2  = "sub kaoya"
    @tc_rcode      = "3"
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
      #�����˻�
      puts "֪·����Ա������������Ա#{@tc_account1}".to_gbk
      rs_login = @iam_obj.manager_del_add(@tc_account1, @tc_passwd, @tc_nickname1)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "�����˻�#{@tc_account1}ʧ��!")

      puts "��������Ա#{@tc_account1}����ϵͳ����Ա#{@tc_account2}".to_gbk
      rs= @iam_obj.manager_del_add(@tc_account2, @tc_passwd, @tc_nickname2, @tc_rcode, @tc_commnets2, @tc_account1, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "��������Ա#{@tc_account1}����ϵͳ����Ա#{@tc_account2}ʧ��!")
      assert_equal(@ts_add_msg, rs["msg"], "��������Ա#{@tc_account1}����ϵͳ����Ա#{@tc_account2}ʧ��!")
    }

    operate("3����ѯ��Ϣ�쳣���룻") {
      puts "����������š�#{@tc_query_str1}�����в�ѯ".to_gbk
      rs1 = @iam_obj.get_mlist_byname(@tc_query_str1, @tc_account1, @tc_passwd, true)
      assert_empty(rs1["res"], "��������Ա#{@tc_account1}����������Ų�ѯ�����ӹ���Ա!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_account2, @tc_account1, @tc_passwd)
      @iam_obj.del_manager(@tc_account1)
    }
  end

}
