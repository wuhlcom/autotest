#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_104", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_account = "klwn20@163.com" #必须为真实有效的邮箱
    @tc_passwd  = "12222627"
    @tc_nickname= "pilipili"
    @tc_rcode   = "5"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      #创建账户
      rs_login = @iam_obj.manager_del_add(@tc_account, @tc_passwd, @tc_nickname, @tc_rcode)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "创建账户#{@tc_account}失败!")
    }

    operate("2、获取知路管理token值；") {
    }

    operate("3、获取管理员列表和管理员uerid号：") {
    }

    operate("4、删除指定的管理员；") {
      p rs= @iam_obj.del_manager(@tc_account)
      assert_equal(@ts_admin_log_rs, rs["result"], "创建账户#{@tc_account}失败!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_account)
    }
  end

}
