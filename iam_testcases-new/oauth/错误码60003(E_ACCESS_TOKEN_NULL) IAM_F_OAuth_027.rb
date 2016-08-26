#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_OAuth_027", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_acc_token =""
  end

  def process

    operate("1、ssh登录到IAM服务器；") {
    }

    operate("2、access_token输入为空") {
      tip = "access_token输入为空"
      rs  = @iam_obj.usr_oauth_info(@tc_acc_token)
      puts "RESULT err_msg:'#{rs['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_oauthtokennul_msg, rs["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_oauthtokennul_code, rs["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_oauthtokennul_desc, rs["err_desc"], "#{tip}返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {

    }
  end

}
