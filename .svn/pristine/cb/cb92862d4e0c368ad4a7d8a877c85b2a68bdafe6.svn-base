#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_134", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_account1  = "wuhuarou@zhilutec.com"
    @tc_account2  = "xianyu@zhilutec.com"
    @tc_passwd    = "123456"
    @tc_nickname1 = "wuhuarou"
    @tc_nickname2 = "xianyu"
    @tc_commnets  = "sub xianyu"
    @tc_rcode     = "3"

  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理员token值；") {
      #创建账户
      puts "知路管理员创建超级管理员#{@tc_account1}".to_gbk
      rs_login = @iam_obj.manager_del_add(@tc_account1, @tc_passwd, @tc_nickname1)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "创建账户#{@tc_account1}失败!")

      puts "超级管理员#{@tc_account1}创建系统管理员#{@tc_account2}".to_gbk
      rs= @iam_obj.manager_del_add(@tc_account2, @tc_passwd, @tc_nickname2, @tc_rcode, @tc_commnets, @tc_account1, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "超级管理员#{@tc_account1}创建系统管理员#{@tc_account2}失败!")
      assert_equal(@ts_add_msg, rs["msg"], "超级管理员#{@tc_account1}创建系统管理员#{@tc_account2}失败!")
    }

    operate("3、查询知路管理员下的管理员信息；（超级管理员、系统管理员查询同上）") {
      rs1 = @iam_obj.get_mlist_byname(@tc_account1)
      assert_equal(@tc_account1, rs1["res"][0]["name"], "知路超级管理员查询超级管理员‘#{@tc_account1}’失败!")
      rs2 = @iam_obj.get_mlist_byname(@tc_account2)
      assert_equal(@tc_account2, rs2["res"][0]["name"], "知路超级管理员查询系统管理员‘#{@tc_account1}’失败!")
      rs3 = @iam_obj.get_mlist_byname(@tc_account2, @tc_account1, @tc_passwd)
      assert_equal(@tc_account2, rs3["res"][0]["name"], "超级管理员#{@tc_account1}查询下级系统管理员#{@tc_account2}失败!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_account2, @tc_account1, @tc_passwd)
      @iam_obj.del_manager(@tc_account1)
    }
  end

}
