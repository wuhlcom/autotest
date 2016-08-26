#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_087", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_account = "klwn20@163.com" #必须为真实有效的邮箱
    @tc_passwd  = "1234567"
    @tc_modpw   = "45678944"
    @tc_nickname= "hahaha1"
  end

  def process

    operate("1、SSH登录IAM系统；") {
      #创建账户
      rs_login = @iam_obj.manager_add_login(@tc_account, @tc_passwd, @tc_nickname)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "创建账户#{@tc_account}失败!")

      #修改密码
      rs = @iam_obj.modify_emailmana_pw(@tc_account, @tc_modpw)
      assert_equal(@ts_admin_log_rs, rs["result"], "修改密码为#{@tc_modpw}失败!")
    }

    operate("2、使用旧密码登录；") {
      rs_login = @iam_obj.manager_login(@tc_account, @tc_passwd)
      puts "RESULT err_msg:#{rs_login['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs_login['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs_login['err_desc']}".encode("GBK")
      assert_equal(@ts_err_acc_code, rs_login["err_code"], "使用修改密码后账户登录返回err_code错误!")
      assert_equal(@ts_err_acc_msg, rs_login["err_msg"], "使用修改密码后账户登录返回err_msg错误!")
      assert_equal(@ts_err_acc_desc, rs_login["err_desc"], "使用修改密码后账户登录返回err_desc错误!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_account)
    }
  end

}
