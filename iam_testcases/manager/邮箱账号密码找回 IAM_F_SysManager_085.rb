#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_085", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_account = "klwn20@163.com" #必须为真实有效的邮箱
    @tc_passwd  = "1234567"
    @tc_modpw   = "45678944"
    @tc_nickname= "hahaha"
  end

  def process

    operate("1、SSH登录IAM系统；") {
    }

    operate("2、获取找回账号token值；") {
    }

    operate("3、修改新密码；") {
      #创建账户
      rs_login = @iam_obj.manager_add_login(@tc_account, @tc_passwd, @tc_nickname)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "创建账户#{@tc_account}失败!")

      #修改密码
      rs = @iam_obj.modify_emailmana_pw(@tc_account, @tc_modpw)
      assert_equal(@ts_admin_log_rs, rs["result"], "修改密码为#{@tc_modpw}失败!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_account)

    }
  end

}
