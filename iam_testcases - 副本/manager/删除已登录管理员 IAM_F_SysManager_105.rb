#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_105", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_account = "klwn20@163.com" #����Ϊ��ʵ��Ч������
    @tc_passwd  = "12222627"
    @tc_nickname= "pilipili"
    @tc_rcode   = "5"
  end

  def process

    operate("1��ssh��¼IAM��������") {

    }

    operate("2����¼��������Ա��") {
      #�����˻�����¼
      rs_login = @iam_obj.manager_add_login(@tc_account, @tc_passwd, @tc_nickname, @tc_rcode)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "�����˻�#{@tc_account}ʧ��!")
    }

    operate("3��ɾ���ù���Ա") {
      rs= @iam_obj.del_manager(@tc_account)
      assert_equal(@ts_admin_log_rs, rs["result"], "�����˻�#{@tc_account}ʧ��!")
    }

    operate("4�����µ�¼�ù���Ա��") {
      rs= @iam_obj.manager_login(@tc_account, @tc_passwd)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_acc_code, rs["err_code"], "����Ϊ��Ӧ��ʾʧ��!")
      assert_equal(@ts_err_acc_msg, rs["err_msg"], "����Ϊ��Ӧ��ʾʧ��!")
      assert_equal(@ts_err_acc_desc, rs["err_desc"], "����Ϊ��Ӧ��ʾʧ��!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_account)
    }
  end

}
