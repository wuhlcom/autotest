#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_090", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_account   = "wuhlcom@126.com" #����Ϊ��ʵ��Ч������
  end

  def process

    operate("1��SSH��¼IAMϵͳ��") {
    }

    operate("2����ȡ�һ��˺�tokenֵ������δע�������") {
     p rs_login = @iam_obj.get_em_token(@tc_account)
      puts "RESULT err_msg:#{rs_login['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs_login['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs_login['err_desc']}".encode("GBK")
      assert_equal(@ts_err_noemail_code, rs_login["err_code"], "ʹ���޸�������˻���¼����err_code����!")
      assert_equal(@ts_err_noemail_msg, rs_login["err_msg"], "ʹ���޸�������˻���¼����err_msg����!")
      assert_equal(@ts_err_noemail_desc, rs_login["err_desc"], "ʹ���޸�������˻���¼����err_desc����!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {

    }
  end

}
