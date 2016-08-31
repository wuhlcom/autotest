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

    operate("1、ssh登录IAM服务器；") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")
    }

    operate("2、获取登录用户access_token值和uid号；") {
      rs     = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
      @uid   = rs["uid"]
      @token = rs["access_token"]
    }

    operate("3、修改密码，旧密码输入有误") {
      tip = "修改密码，旧密码输入有误"
      @tc_old_pwd = @tc_usr_pw + "err"
      rs         = @iam_obj.mofify_user_pwd(@tc_old_pwd, @tc_new_pwd, @uid, @token)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal( @ts_err_oldpw_code, rs["err_code"], "#{tip}返回code错误!")
      assert_equal( @ts_err_oldpw_msg, rs["err_msg"], "#{tip}返回msg错误")
      assert_equal( @ts_err_oldpw_desc, rs["err_desc"], "#{tip}返回desc错误!")
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
    }
  end

}
