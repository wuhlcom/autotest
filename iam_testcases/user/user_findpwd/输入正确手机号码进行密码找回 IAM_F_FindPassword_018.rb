#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_FindPassword_018", "level" => "P2", "auto" => "n"}

  def prepare

    @tc_phone_usr   = "13744444444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}
    @tc_pwd_new     = "12345678"
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs = @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")

      rs2 = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs2["result"], "�û�#{@tc_phone_usr}��¼ʧ��")
    }

    operate("2����ȡ�ֻ���֤�룻") {

    }

    operate("3���޸����룻") {
      rs1 = @iam_obj.usr_modpw_mobile(@tc_phone_usr, @tc_pwd_new)
      assert_equal(1, rs1["result"], "�ֻ��޸�����ʧ��")

      rs2 = @iam_obj.user_login(@tc_phone_usr, @tc_pwd_new)
      assert_equal(@ts_add_rs, rs2["result"], "�û�#{@tc_phone_usr}ʹ��������#{@tc_pwd_new}��¼ʧ��")
    }
  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_pwd_new)
    }
  end

}
