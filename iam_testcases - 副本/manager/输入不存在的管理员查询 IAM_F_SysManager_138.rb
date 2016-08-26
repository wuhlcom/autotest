#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_138", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_account1   = "shengyupian@zhilutec.com"
    @tc_account2   = "sanwenyu@zhilutec.com"
    @tc_query_str1 = "2550@zhilutec.com"
    @tc_passwd     = "123456"
    @tc_nickname1  = "shengyupian"
    @tc_nickname2  = "sanwenyu"
    @tc_commnets2  = "sub sanwenyu"
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
    }

    operate("3、查询不存在的管理员；") {
      puts "输入不存的账户的查询‘#{@tc_query_str1}’进行查询".to_gbk
      rs1 = @iam_obj.get_mlist_byname(@tc_query_str1, @tc_account1, @tc_passwd)
      assert_empty(rs1["res"], "超级管理员#{@tc_account1}输入不存的账户查询应该查询不到子管理员!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_account2, @tc_account1, @tc_passwd)
      @iam_obj.del_manager(@tc_account1)
    }
  end

}
