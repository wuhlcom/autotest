#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_UserCenter_013", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13700004444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}
    @tc_new_pwd     = "1234567"
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")
    }

    operate("2����ȡ��¼�û�access_tokenֵ��uid�ţ�") {
      rs     = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
      @uid   = rs["uid"]
      @token = rs["access_token"]
    }

    operate("3���޸����룬��������������") {
      tip = "�޸����룬��������������"
      @tc_old_pwd = @tc_usr_pw + "err"
      rs         = @iam_obj.mofify_user_pwd(@tc_old_pwd, @tc_new_pwd, @uid, @token)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal( @ts_err_oldpw_code, rs["err_code"], "#{tip}����code����!")
      assert_equal( @ts_err_oldpw_msg, rs["err_msg"], "#{tip}����msg����")
      assert_equal( @ts_err_oldpw_desc, rs["err_desc"], "#{tip}����desc����!")
    }

  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
    }
  end

}
