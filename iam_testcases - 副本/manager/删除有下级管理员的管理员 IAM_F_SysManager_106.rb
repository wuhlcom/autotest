#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_106", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_account1 = "klwn201@163.com"
    @tc_account2 = "klwn202@163.com"
    @tc_passwd   = "123456"
    @tc_nickname = "pilipala"
    @tc_commnets = "sub manager"
    @tc_rcode    = "3"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理token值；") {
    }

    operate("3、知路管理员下新增超级管理员；") {
      #创建账户
      puts "知路管理员创建超级管理员#{@tc_account1}".to_gbk
      rs_login = @iam_obj.manager_del_add(@tc_account1, @tc_passwd, @tc_nickname)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "创建账户#{@tc_account1}失败!")
    }

    operate("4、超级管理员下新增系统管理员；") {
      puts "超级管理员#{@tc_account1}创建系统管理员#{@tc_account2}".to_gbk
      rs= @iam_obj.manager_del_add(@tc_account2, @tc_passwd, @tc_nickname, @tc_rcode, @tc_commnets, @tc_account1, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "超级管理员#{@tc_account1}创建系统管理员#{@tc_account2}失败!")
      assert_equal(@ts_add_msg, rs["msg"], "超级管理员#{@tc_account1}创建系统管理员#{@tc_account2}失败!")
    }

    operate("5、知路管理员下获取管理员列表和管理员uerid号：") {
    }

    operate("6、删除指定的管理员；") {
      rs= @iam_obj.del_manager(@tc_account1)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal( @ts_err_manadel_code, rs["err_code"], "删除存在下级管理员的管理员返回err_code错误!")
      assert_equal( @ts_err_manadel_msg, rs["err_msg"], "删除存在下级管理员的管理员返回err_msg错误!")
      assert_equal( @ts_err_manadel_desc, rs["err_desc"], "删除存在下级管理员的管理员返回err_desc错误!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_account2, @tc_account1, @tc_passwd)
      @iam_obj.del_manager(@tc_account1)
    }
  end

}
