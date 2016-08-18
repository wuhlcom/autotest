#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_077", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name     = "13566660000"
    @tc_add_passwd   = "123456"
    @tc_mod_passwd   = "12345678"
    @tc_nickname     = "hahawangle"
    @tc_timeout_time = 150
  end

  def process

    operate("1、SSH登录IAM系统；") {
    }

    operate("2、获取手机验证码；") {
      #先添加管理员
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_add_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "添加管理员#{@tc_man_name}失败!")
    }

    operate("3、输入新密码、验证码过期；") {
      rs_recode = @iam_obj.request_mobile_code(@tc_man_name)
      code      = rs_recode["code"]
      puts "获取得验证码为#{code},等待#{@tc_timeout_time}秒，验证码超时".to_gbk
      sleep @tc_timeout_time
      puts "使用过期验证码，找回手机密码".to_gbk
      rs = @iam_obj.phone_manager_modpw(@tc_man_name, @tc_mod_passwd, code)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_pcoderr_msg, rs["err_msg"], "输入过期的验证码返回错误消息不正确!")
      assert_equal(@ts_err_pcoderr_code, rs["err_code"], "输入过期的验证码返回错误code不正确!")
      assert_equal(@ts_err_pcoderr_desc, rs["err_desc"], "输入过期的验证码返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
