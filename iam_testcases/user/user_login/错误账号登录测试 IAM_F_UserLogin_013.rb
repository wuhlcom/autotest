#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_UserLogin_001", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_usr_name    = "lilup@zhilutec.com"
    @tc_usr_pwd     = "123456"
    @tc_err_usrname = "err10086@zhilutec.com"
    @tc_err_code    = "10001"
    @tc_args        ={type: "account", cond: @tc_usr_name}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2���û���¼���˺��������") {
      @iam_obj.email_usr_reg(@tc_usr_name, @tc_usr_pwd, @tc_args)

      rs = @iam_obj.user_login(@tc_err_usrname, @ts_usr_pwd)
      assert_equal(@tc_err_code, rs["err_code"], "ʹ�ô����˺ŵ�¼ʱ��¼�ɹ������ǵ�¼ʧ�ܵ��Ƿ��صĴ����벻��ȷ")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_usr(@tc_usr_name, @tc_usr_pwd)
    }
  end

}
