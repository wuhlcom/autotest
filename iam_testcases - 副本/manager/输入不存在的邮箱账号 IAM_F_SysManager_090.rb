#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_090", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_account   = "wuhlcom@126.com" #必须为真实有效的邮箱
  end

  def process

    operate("1、SSH登录IAM系统；") {
    }

    operate("2、获取找回账号token值，输入未注册的邮箱") {
     p rs_login = @iam_obj.get_em_token(@tc_account)
      puts "RESULT err_msg:#{rs_login['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs_login['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs_login['err_desc']}".encode("GBK")
      assert_equal(@ts_err_noemail_code, rs_login["err_code"], "使用修改密码后账户登录返回err_code错误!")
      assert_equal(@ts_err_noemail_msg, rs_login["err_msg"], "使用修改密码后账户登录返回err_msg错误!")
      assert_equal(@ts_err_noemail_desc, rs_login["err_desc"], "使用修改密码后账户登录返回err_desc错误!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {

    }
  end

}
