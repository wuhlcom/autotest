#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_137", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_account1   = "bengda@zhilutec.com"
    @tc_account2   = "13777777777"
    @tc_account3   = "bengbengda@zhilutec.com"

    @tc_query_str1 = "137"
    @tc_query_str2 = "bengbeng"
    @tc_query_str3 = "@zhilutec.com"

    @tc_passwd     = "123456"
    @tc_nickname1  = "bengda"
    @tc_nickname2  = "13777777777"
    @tc_nickname3  = "bengbengda"
    @tc_commnets2   = "sub 13777777777"
    @tc_commnets3   = "sub bengbengda"
    @tc_rcode      = "3"
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
      rs= @iam_obj.manager_del_add(@tc_account2, @tc_passwd, @tc_nickname2, @tc_rcode, @tc_commnets2, @tc_account1, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "超级管理员#{@tc_account1}创建系统管理员#{@tc_account2}失败!")
      assert_equal(@ts_add_msg, rs["msg"], "超级管理员#{@tc_account1}创建系统管理员#{@tc_account2}失败!")

      puts "超级管理员#{@tc_account1}创建系统管理员#{@tc_account3}".to_gbk
      rs= @iam_obj.manager_del_add(@tc_account3, @tc_passwd, @tc_nickname3, @tc_rcode, @tc_commnets3, @tc_account1, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "超级管理员#{@tc_account1}创建系统管理员#{@tc_account3}失败!")
      assert_equal(@ts_add_msg, rs["msg"], "超级管理员#{@tc_account1}创建系统管理员#{@tc_account3}失败!")
    }

    operate("3、模糊查询知路管理员下的管理员信息；") {
      puts "输入‘#{@tc_query_str1}’进行模糊查询".to_gbk
      rs1 = @iam_obj.get_mlist_byname(@tc_query_str1, @tc_account1, @tc_passwd)
      assert_equal(@tc_account2, rs1["res"][0]["name"], "超级管理员#{@tc_account1}输入‘#{@tc_query_str1}’模糊查询失败!")

      puts "输入‘#{@tc_query_str2}’进行模糊查询".to_gbk
      rs2 = @iam_obj.get_mlist_byname(@tc_query_str2, @tc_account1, @tc_passwd)
      assert_equal(@tc_account3, rs2["res"][0]["name"], "超级管理员#{@tc_account1}输入‘#{@tc_query_str2}’模糊查询失败!")

      puts "输入‘#{@tc_query_str3}’进行模糊查询".to_gbk
      rs3 = @iam_obj.get_mlist_byname(@tc_query_str3, @tc_account1, @tc_passwd)
      assert_equal(@tc_account3, rs3["res"][0]["name"], "超级管理员#{@tc_account1}输入‘#{@tc_query_str3}’模糊查询失败!")
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_account2, @tc_account1, @tc_passwd)
      @iam_obj.del_manager(@tc_account3, @tc_account1, @tc_passwd)
      @iam_obj.del_manager(@tc_account1)
    }
  end

}
