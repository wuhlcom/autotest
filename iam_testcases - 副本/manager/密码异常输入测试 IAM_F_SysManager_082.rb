#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_082", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "13444444245"
    @tc_nickname = "phone_mana"
    @tc_add_pw   = "123456"
    @tc_mod_pw1  = "你好你好你好"
    @tc_mod_pw2  = "1^#!@*()@45"
    @tc_mod_pw3  = "１４５６７８９０"
  end

  def process

    operate("1、SSH登录IAM系统；") {
    }

    operate("2、获取手机验证码；") {
    }

    operate("3、新密码密码异常输入；") {
      @iam_obj.del_manager(@tc_man_name)
      puts "原密码为#{@tc_add_pw},修改密码为#{@tc_mod_pw1}".to_gbk
      rs = @iam_obj.mobile_manager_modpw(@tc_man_name, @tc_mod_pw1, @tc_add_pw, @tc_nickname)
      puts "RESULT err_msg:'#{rs['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_pwerr_msg, rs["err_msg"], "修改密码为#{@tc_mod_pw1}返回错误消息不正确!")
      assert_equal(@ts_err_pwerr_code, rs["err_code"], "修改密码为#{@tc_mod_pw1}返回错误code不正确!")
      assert_equal(@ts_err_pwerr_desc, rs["err_desc"], "修改密码为#{@tc_mod_pw1}返回错误desc不正确!")
      sleep 5
      puts "修改密码为#{@tc_mod_pw2}".to_gbk
      rs_recode = @iam_obj.request_mobile_code(@tc_man_name)
      code      = rs_recode["code"]
      puts "获取得验证码为#{code}".to_gbk
      rs = @iam_obj.phone_manager_modpw(@tc_man_name, @tc_mod_pw2, code)
      puts "RESULT err_msg:'#{rs['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_pwerr_msg, rs["err_msg"], "修改密码为#{@tc_mod_pw2}返回错误消息不正确!")
      assert_equal(@ts_err_pwerr_code, rs["err_code"], "修改密码为#{@tc_mod_pw2}返回错误code不正确!")
      assert_equal(@ts_err_pwerr_desc, rs["err_desc"], "修改密码为#{@tc_mod_pw2}返回错误desc不正确!")
      sleep 5
      puts "修改密码为#{@tc_mod_pw3}".to_gbk
      rs_recode = @iam_obj.request_mobile_code(@tc_man_name)
      code      = rs_recode["code"]
      puts "获取得验证码为#{code}".to_gbk
      rs = @iam_obj.phone_manager_modpw(@tc_man_name, @tc_mod_pw3, code)
      puts "RESULT err_msg:'#{rs['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_pwerr_msg, rs["err_msg"], "修改密码为#{@tc_mod_pw3}返回错误消息不正确!")
      assert_equal(@ts_err_pwerr_code, rs["err_code"], "修改密码为#{@tc_mod_pw3}返回错误code不正确!")
      assert_equal(@ts_err_pwerr_desc, rs["err_desc"], "修改密码为#{@tc_mod_pw3}返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
