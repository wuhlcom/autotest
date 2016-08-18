#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_108", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name    = "managertest@zhilutec.com"
    @tc_subman_name = "submanagertest@zhilutec.com"
    @tc_nickname    = "manager"
    @tc_subnickname = "submanager"
    @tc_passwd      = "zhilutec"
    @tc_comment     ="submanager"
    @tc_rcode       = "3"
    @tc_args        = {"nickname" => "xiguashule", "comments" => "西瓜好甜"}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、知路管理员下新增超级管理员；") {
      #如果管理员已经存在则先删除
      @iam_obj.del_manager(@tc_subman_name, @tc_man_name, @tc_passwd)
      @iam_obj.del_manager(@tc_man_name)
      puts "新增管理员:‘#{@tc_man_name}’".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "添加系统管理员失败!")
      assert_equal(@ts_add_msg, rs["msg"], "添加系统管理员失败!")
    }

    operate("3、超级管理员添加子管理员") {
      puts "管理员:‘#{@tc_man_name}’添加子管理员#{@tc_subman_name}".encode("GBK")
      rs = @iam_obj.manager_add(@tc_subman_name, @tc_subnickname, @tc_passwd, @tc_rcode, @tc_comment, @tc_man_name, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "添加系统子管理员失败!")
    }

    operate("4、超级管理员登录，修改子管理员信息") {
      rs = @iam_obj.edit_submana_info(@tc_subman_name, @tc_args, @tc_man_name, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "系统管理员修改子管理员信息失败!")
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_subman_name, @tc_man_name, @tc_passwd)
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
