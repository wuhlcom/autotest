#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_089", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_account  = "klwn20@163.com" #����Ϊ��ʵ��Ч������
    @tc_passwd   = "1234567"
    @tc_modpw    = "45678944"
    @tc_nickname = "hahaha1"
    @tc_err_email = "klwn20-163.com"
  end

  def process

    operate("1��SSH��¼IAMϵͳ��") {
      #�����˻�
      rs_login = @iam_obj.manager_add_login(@tc_account, @tc_passwd, @tc_nickname)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "�����˻�#{@tc_account}ʧ��!")
    }

    operate("2����ȡ�һ��˺�tokenֵ���������������ʽ") {
      rs_login = @iam_obj.get_em_token(@tc_err_email)
      puts "RESULT err_msg:#{rs_login['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs_login['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs_login['err_desc']}".encode("GBK")
      assert_equal(@ts_err_email_code, rs_login["err_code"], "ʹ���޸�������˻���¼����err_code����!")
      assert_equal(@ts_err_email_msg, rs_login["err_msg"], "ʹ���޸�������˻���¼����err_msg����!")
      assert_equal(@ts_err_email_desc, rs_login["err_desc"], "ʹ���޸�������˻���¼����err_desc����!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_account)
    }
  end

}
