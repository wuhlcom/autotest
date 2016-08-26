#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_105", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_account = "klwn20@163.com" #必须为真实有效的邮箱
    @tc_passwd  = "12222627"
    @tc_nickname= "pilipili"
    @tc_rcode   = "5"
  end

  def process

    operate("1、ssh登录IAM服务器；") {

    }

    operate("2、登录超级管理员；") {
      #创建账户并登录
      rs_login = @iam_obj.manager_add_login(@tc_account, @tc_passwd, @tc_nickname, @tc_rcode)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "创建账户#{@tc_account}失败!")
    }

    operate("3、删除该管理员") {
      rs= @iam_obj.del_manager(@tc_account)
      assert_equal(@ts_admin_log_rs, rs["result"], "创建账户#{@tc_account}失败!")
    }

    operate("4、重新登录该管理员；") {
      rs= @iam_obj.manager_login(@tc_account, @tc_passwd)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_acc_code, rs["err_code"], "密码为空应提示失败!")
      assert_equal(@ts_err_acc_msg, rs["err_msg"], "密码为空应提示失败!")
      assert_equal(@ts_err_acc_desc, rs["err_desc"], "密码为空应提示失败!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_account)
    }
  end

}
