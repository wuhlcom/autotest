#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_079", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "13444444445"
    @tc_nickname = "phone_manager"
    @tc_add_pw   = "123456"
    @tc_mod_pw1  = "456789"
    @tc_mod_pw2  = "0123456789"*3+"22"
    @tc_mod_pw3  = "1234_abcd"
  end

  def process

    operate("1、SSH登录IAM系统；") {
    }

    operate("2、获取手机验证码；") {
    }
    # mobile_manager_modpw(phone, mod_pw, add_pw="123456", nickname="autotest", url=MANAGER_MODPW_MOB_URL)
    operate("3、输入新密码（密码正常范围格式正确）；") {
      @iam_obj.del_manager(@tc_man_name)
      puts "原密码为#{@tc_add_pw},修改密码为#{@tc_mod_pw1},密码长度#{@tc_mod_pw1.size}".to_gbk
      rs_mod1 = @iam_obj.mobile_manager_modpw(@tc_man_name, @tc_mod_pw1, @tc_add_pw, @tc_nickname)
      puts "RESULT:#{rs_mod1}".encode("GBK")
      assert_equal(@ts_add_rs, rs_mod1["result"], "修改手机账户超级管理员密码失败!")


      puts "修改密码为#{@tc_mod_pw2},密码长度#{@tc_mod_pw2.size}".to_gbk
      rs_mod2 =@iam_obj.manager_modpw_mobile(@tc_man_name, @tc_mod_pw2)
      puts "RESULT:#{rs_mod2}".encode("GBK")
      assert_equal(@ts_add_rs, rs_mod2["result"], "修改手机账户超级管理员密码为#{@tc_mod_pw2}失败!")

      rs_rlogin2 = @iam_obj.manager_login(@tc_man_name, @tc_mod_pw2)
      assert_equal(@ts_admin_log_rs, rs_rlogin2["result"], "修改管理员密码为#{@tc_mod_pw2}后登录失败!")
      puts "RESULT name:#{rs_rlogin2['name']}".encode("GBK")
      assert_equal(@tc_man_name, rs_rlogin2["name"], "修改管理员密码为#{@tc_mod_pw2}后登录返回name信息错误!")
      puts "RESULT nickname:#{rs_rlogin2['nickname']}".encode("GBK")
      assert_equal(@tc_nickname, rs_rlogin2["nickname"], "修改管理员密码为#{@tc_mod_pw2}后登录返回nickname信息错误!")
################################################################################
      puts "修改密码为#{@tc_mod_pw3},密码长度#{@tc_mod_pw3.size}".to_gbk
      rs_mod3=@iam_obj.manager_modpw_mobile(@tc_man_name, @tc_mod_pw3)
      puts "RESULT:#{rs_mod3}".encode("GBK")
      assert_equal(@ts_add_rs, rs_mod3["result"], "修改手机账户超级管理员密码为#{@tc_mod_pw3}失败!")

      rs_rlogin3 = @iam_obj.manager_login(@tc_man_name, @tc_mod_pw3)
      assert_equal(@ts_admin_log_rs, rs_rlogin3["result"], "修改手机账户超级管理员密码为#{@tc_mod_pw3}失败!!")
      puts "RESULT name:#{rs_rlogin3['name']}".encode("GBK")
      assert_equal(@tc_man_name, rs_rlogin3["name"], "修改管理员密码为#{@tc_mod_pw2}后登录返回name信息错误!")
      puts "RESULT nickname:#{rs_rlogin3['nickname']}".encode("GBK")
      assert_equal(@tc_nickname, rs_rlogin3["nickname"], "修改管理员密码为#{@tc_mod_pw3}后登录返回nickname信息错误!!")

    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
