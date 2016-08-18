#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_OAuth_028", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_acc_token ="fa754177ef40979706d8e78275c22c1f"
    @tc_acc_token.reverse!
  end

  def process

    operate("1��ssh��¼��IAM��������") {
    }

    operate("2��access_token�������") {
      tip = "access_token�������"
      rs  = @iam_obj.usr_oauth_info(@tc_acc_token)
      puts "RESULT err_msg:'#{rs['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_oauthtoken_msg, rs["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_oauthtoken_code, rs["err_code"], "#{tip}���ش���code����ȷ!")
      assert_equal(@ts_err_oauthtoken_desc, rs["err_desc"], "#{tip}���ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {

    }
  end

}
