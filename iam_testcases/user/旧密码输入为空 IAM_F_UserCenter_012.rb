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

    operate("1、ssh登录IAM服务器；") {
      rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@ts_phone_usr}注册失败")
    }

    operate("2、获取登录用户access_token值和uid号；") {
      rs     = @iam_obj.user_login(@ts_phone_usr, @ts_usr_pw)
      @uid   = rs["uid"]
      @token = rs["access_token"]
    }

    operate("3、修改密码，旧密码输入为空") {
      tip ="修改密码，旧密码输入为空"
      rs = @iam_obj.mofify_user_pwd(@tc_old_pwd, @tc_new_pwd, @uid, @token)
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
      @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
    }
  end

}
