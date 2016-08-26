#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_137", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_account1   = "bengda@zhilutec.com"
    @tc_account2   = "13777777777"
    @tc_account3   = "bengbengda@zhilutec.com"

    @tc_query_str1 = "137"
    @tc_query_str2 = "bengbeng"
    @tc_query_str3 = "@zhilutec.com"

    @tc_passwd     = "123456"
    @tc_nickname1  = "bengda"
    @tc_nickname2  = "13777777777"
    @tc_nickname3  = "bengbengda"
    @tc_commnets2   = "sub 13777777777"
    @tc_commnets3   = "sub bengbengda"
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

      puts "��������Ա#{@tc_account1}����ϵͳ����Ա#{@tc_account3}".to_gbk
      rs= @iam_obj.manager_del_add(@tc_account3, @tc_passwd, @tc_nickname3, @tc_rcode, @tc_commnets3, @tc_account1, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "��������Ա#{@tc_account1}����ϵͳ����Ա#{@tc_account3}ʧ��!")
      assert_equal(@ts_add_msg, rs["msg"], "��������Ա#{@tc_account1}����ϵͳ����Ա#{@tc_account3}ʧ��!")
    }

    operate("3��ģ����ѯ֪·����Ա�µĹ���Ա��Ϣ��") {
      puts "���롮#{@tc_query_str1}������ģ����ѯ".to_gbk
      rs1 = @iam_obj.get_mlist_byname(@tc_query_str1, @tc_account1, @tc_passwd)
      assert_equal(@tc_account2, rs1["res"][0]["name"], "��������Ա#{@tc_account1}���롮#{@tc_query_str1}��ģ����ѯʧ��!")

      puts "���롮#{@tc_query_str2}������ģ����ѯ".to_gbk
      rs2 = @iam_obj.get_mlist_byname(@tc_query_str2, @tc_account1, @tc_passwd)
      assert_equal(@tc_account3, rs2["res"][0]["name"], "��������Ա#{@tc_account1}���롮#{@tc_query_str2}��ģ����ѯʧ��!")

      puts "���롮#{@tc_query_str3}������ģ����ѯ".to_gbk
      rs3 = @iam_obj.get_mlist_byname(@tc_query_str3, @tc_account1, @tc_passwd)
      assert_equal(@tc_account3, rs3["res"][0]["name"], "��������Ա#{@tc_account1}���롮#{@tc_query_str3}��ģ����ѯʧ��!")
    }

  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_account2, @tc_account1, @tc_passwd)
      @iam_obj.del_manager(@tc_account3, @tc_account1, @tc_passwd)
      @iam_obj.del_manager(@tc_account1)
    }
  end

}
