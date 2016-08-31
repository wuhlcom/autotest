#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_UserCenter_016", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13700008888"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}
    @tc_new_pwd     = "12345678"
    @tc_err_code    = "10001"
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")
    }

    operate("2����¼�û���ȡaccess_tokenֵ��uid�ţ�") {
      rs     = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
      @uid   = rs["uid"]
      @token = rs["access_token"]
    }

    operate("3���޸����룻") {
      @rs = @iam_obj.mofify_user_pwd(@tc_usr_pw, @tc_new_pwd, @uid, @token)
      assert_equal(1, @rs["result"], "�޸�����ʧ��")
    }

    operate("4��ʹ�þ������¼��") {
      tip="�޸������ʹ�þ������¼"
      rs = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_login_code, rs["err_code"], "#{tip}����code����!")
      assert_equal(@ts_err_login, rs["err_msg"], "#{tip}����msg����")
      assert_equal(@ts_err_login_desc, rs["err_desc"], "#{tip}����desc����!")
    }

  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_new_pwd)
    }
  end

}
