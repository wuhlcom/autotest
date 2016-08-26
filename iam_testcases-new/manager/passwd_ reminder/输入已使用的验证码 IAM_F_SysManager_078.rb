#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_078", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name    = "13566600000"
    @tc_add_passwd  = "123456"
    @tc_mod_passwd1 = "12345678"
    @tc_mod_passwd2 = "123456789"
    @tc_nickname    = "hahawangle"

  end

  def process

    operate("1、SSH登录IAM系统；") {
    }

    operate("2、获取手机验证码；") {
      #先添加手机管理员
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_add_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "添加管理员#{@tc_man_name}失败!")
    }

    operate("3、输入新密码、验证码已使用；") {
      #请求验证码
      rs_recode = @iam_obj.request_mobile_code(@tc_man_name)
      puts "请求的验证码为#{rs_recode["code"]}".to_gbk
      #获取验证码
      rs_getcode= @iam_obj.get_mobile_code(@tc_man_name)
      puts "获取的验证码#{rs_getcode["code"]}".to_gbk
      rs_rlogin1 = @iam_obj.manager_login(@tc_man_name, @tc_mod_pw1)
      #找回手机密码
      puts "验证码#{rs_getcode["code"]}找回密码".to_gbk
      rs         = @iam_obj.phone_manager_modpw(@tc_man_name, @tc_mod_passwd1, rs_getcode["code"])
      assert_equal(@ts_admin_log_rs, rs["result"], "修改管理员密码为#{@tc_mod_pw1}失败!")


      #使用相同的验证码再找回一次手机密码
      puts "再一次使用验证码#{rs_getcode["code"]}找回密码".to_gbk
      rs = @iam_obj.phone_manager_modpw(@tc_man_name, @tc_mod_passwd2, rs_getcode["code"])
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_pcodnul_msg, rs["err_msg"], "输入被使用过的验证码返回错误消息不正确!")
      assert_equal(@ts_err_pcodnul_code, rs["err_code"], "输入被使用过的验证码返回错误code不正确!")
      assert_equal(@ts_err_pcodnul_desc, rs["err_desc"], "输入被使用过的验证码返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {

    }
  end

}
