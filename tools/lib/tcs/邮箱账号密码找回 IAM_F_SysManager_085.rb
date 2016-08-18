#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_085", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_account = "378433825322@qq.com"
    @tc_passwd  = "1234567"
    @tc_modpw   = "45678944"
    @tc_nickname= "hahaha"
  end

  def process

    operate("1��SSH��¼IAMϵͳ��") {
    }

    operate("2����ȡ�һ��˺�tokenֵ��") {
    }

    operate("3���޸������룻") {
      #�����˻�
      rs_login = @iam_obj.manager_add_login(@tc_account, @tc_passwd, @tc_nickname)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "�����˻�#{@tc_account}ʧ��!")

      #�޸�����
      rs = @iam_obj.modify_emailmana_pw(@tc_account, @tc_modpw)
      assert_equal(@ts_admin_log_rs, rs["result"], "�޸�����Ϊ#{@tc_mod_pw1}���ش�����Ϣ����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {

    }
  end

}
