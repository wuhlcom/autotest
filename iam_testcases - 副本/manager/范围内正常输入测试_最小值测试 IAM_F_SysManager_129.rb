#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_129", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_man_name = "yanjing@zhilutec.com"
    @tc_nickname = "眼睛"
    @tc_passwd   = "zhilutec"
    @tc_comments = "眼睛疼"
    @tc_args1    = {"nickname" => @tc_nickname, "comments" => "0"}

  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取系统管理员uid和token值；") {
      #如果管理员已经存在则先删除
      @iam_obj.del_manager(@tc_man_name)
      puts "新增管理员:‘#{@tc_man_name}’".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd, "2", @tc_comments)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "添加系统管理员失败!")
      assert_equal(@ts_add_msg, rs["msg"], "添加系统管理员失败!")
    }

    operate("3、修改comments信息为一个字符；") {
      puts "修改comments为‘#{@tc_args1["comments"]}’的长度为#{@tc_args1["comments"].size}".to_gbk
      rs = @iam_obj.edit_mana_info(@tc_args1, @tc_man_name, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "系统管理员备注为#{@tc_args1["comments"]}失败!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
