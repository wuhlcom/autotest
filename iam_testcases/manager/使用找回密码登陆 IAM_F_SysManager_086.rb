#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_086", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_account = "klwn20@163.com" #����Ϊ��ʵ��Ч������
    @tc_passwd  = "1234567"
    @tc_modpw   = "abcdefghi"
    @tc_nickname= "hahaha"
  end

  def process

    operate("1��SSH��¼IAMϵͳ��") {
      #�����˻�
      rs_login = @iam_obj.manager_add_login(@tc_account, @tc_passwd, @tc_nickname)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "�����˻�#{@tc_account}ʧ��!")

      #�޸�����
      rs = @iam_obj.modify_emailmana_pw(@tc_account, @tc_modpw)
      assert_equal(@ts_admin_log_rs, rs["result"], "�޸�����Ϊ#{@tc_modpw}ʧ��!")
    }

    operate("2��ʹ���������¼��") {
      rs_login = @iam_obj.manager_login(@tc_account, @tc_modpw)
      puts "RESULT err_msg:#{rs_login['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs_login['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs_login['err_desc']}".encode("GBK")
      assert_equal(@ts_err_pwformat_code, rs_login["err_code"], "����Ϊ��Ӧ��ʾʧ��!")
      assert_equal(@ts_err_pwformat, rs_login["err_msg"], "����Ϊ��Ӧ��ʾʧ��!")
      assert_equal(@ts_err_pwformat_desc, rs_login["err_desc"], "����Ϊ��Ӧ��ʾʧ��!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_account)
    }
  end

}
