#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_088", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_account = "klwn20@163.com" #必须为真实有效的邮箱
    @tc_passwd  = "1222267"
    @tc_modpw   = "22222222"
    @tc_nickname= "pilipili"
    @tc_emnull  = ""
  end

  def process

    operate("1、SSH登录IAM系统；") {
      #创建账户
      rs_login = @iam_obj.manager_add_login(@tc_account, @tc_passwd, @tc_nickname)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "创建账户#{@tc_account}失败!")
    }

    operate("2、获取找回账号token值，邮箱为空；") {
      rs_login = @iam_obj.get_em_token(@tc_emnull)
      puts "RESULT err_msg:#{rs_login['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs_login['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs_login['err_desc']}".encode("GBK")
      assert_equal(@ts_err_email_code, rs_login["err_code"], "使用修改密码后账户登录返回err_code错误!")
      assert_equal(@ts_err_email_msg, rs_login["err_msg"], "使用修改密码后账户登录返回err_msg错误!")
      assert_equal(@ts_err_email_desc, rs_login["err_desc"], "使用修改密码后账户登录返回err_desc错误!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_account)
    }
  end

}
