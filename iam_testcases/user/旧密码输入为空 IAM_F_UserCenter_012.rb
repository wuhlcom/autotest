#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_UserCenter_012", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_old_pwd     = ""
    @tc_new_pwd     = "1234567"
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@ts_phone_usr}ע��ʧ��")
    }

    operate("2����ȡ��¼�û�access_tokenֵ��uid�ţ�") {
      rs     = @iam_obj.user_login(@ts_phone_usr, @ts_usr_pw)
      @uid   = rs["uid"]
      @token = rs["access_token"]
    }

    operate("3���޸����룬����������Ϊ��") {
      tip ="�޸����룬����������Ϊ��"
      rs = @iam_obj.mofify_user_pwd(@tc_old_pwd, @tc_new_pwd, @uid, @token)
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
      @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
    }
  end

}
