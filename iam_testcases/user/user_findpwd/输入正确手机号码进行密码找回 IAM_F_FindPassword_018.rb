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

    operate("1、ssh登录IAM服务器；") {
      rs = @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")

      rs2 = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs2["result"], "用户#{@tc_phone_usr}登录失败")
    }

    operate("2、获取手机验证码；") {

    }

    operate("3、修改密码；") {
      rs1 = @iam_obj.usr_modpw_mobile(@tc_phone_usr, @tc_pwd_new)
      assert_equal(1, rs1["result"], "手机修改密码失败")

      rs2 = @iam_obj.user_login(@tc_phone_usr, @tc_pwd_new)
      assert_equal(@ts_add_rs, rs2["result"], "用户#{@tc_phone_usr}使用新密码#{@tc_pwd_new}登录失败")
    }
  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_pwd_new)
    }
  end

}
