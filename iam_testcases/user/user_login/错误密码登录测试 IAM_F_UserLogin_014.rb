#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_UserLogin_001", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_usr_name    = "lilup@zhilutec.com"
    @tc_usr_pwd     = "123456"
    @tc_err_usrname = "err10086@zhilutec.com"
    @tc_err_code    = "10001"
    @tc_args        = {type: "account", cond: @tc_usr_name}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、用户登录，密码输入错误；") {
      @iam_obj.email_usr_reg(@tc_usr_name, @tc_usr_pwd, @tc_args)

      rs = @iam_obj.user_login(@ts_usr_name, @tc_err_usrpwd)
      assert_equal(@tc_err_code, rs["err_code"], "使用错误密码登录时登录成功或者是登录失败但是返回的错误码不正确")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@tc_usr_name, @tc_usr_pwd)
    }
  end

}
