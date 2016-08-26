#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_118", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "autotest_001@zhilutec.com"
    @tc_nickname = "autotest_whl"
    @tc_passwd   = "123456"
    @tc_old_pw   = ""
    @tc_new_pw   = "12345678"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      #添加管理员
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "添加超级管理员失败!")
    }

    operate("2、获取知路管理员id和token值；") {
    }

    operate("3、旧密码输入为空；") {
      # @iam_obj.mana_modpw(@tc_old_pw, @tc_new_pw, @tc_man_name) #不能调用此接口,此接口使用前提是管理必须登录成功
      rs     = @iam_obj.manager_login(@tc_man_name, @tc_passwd)
      uid    = rs["uid"]
      token  = rs["token"]
      tip    = "旧密码输入为空"
      rs_mod = @iam_obj.manager_modpw(@tc_old_pw, @tc_new_pw, uid, token)
      puts "RESULT err_msg:#{rs_mod['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs_mod['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs_mod['err_desc']}".encode("GBK")
      assert_equal(@ts_err_oldpw_code, rs_mod["err_code"], "#{tip}提示code错误!")
      assert_equal(@ts_err_oldpw_msg, rs_mod["err_msg"], "#{tip}提示msg错误!")
      assert_equal(@ts_err_oldpw_desc, rs_mod["err_desc"], "#{tip}提示desc错误!")
    }

  end

  def clearup

    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name)
    }

  end

}
