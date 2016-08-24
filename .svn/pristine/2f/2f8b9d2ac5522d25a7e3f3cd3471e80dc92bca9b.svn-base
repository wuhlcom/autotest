#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_110", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "w2test@zhilutec.com"
    @tc_nickname = "桃子"
    @tc_passwd   = "zhilutec"
    @tc_newpw    = "123456"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取管理员token值和id号；") {
      #如果管理员已经存在则先删除
      @iam_obj.del_manager(@tc_man_name)
      puts "新增管理员:‘#{@tc_man_name}’".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "添加系统管理员失败!")
      assert_equal(@ts_add_msg, rs["msg"], "添加系统管理员失败!")
    }

    operate("3、修改密码：") {
      rs = @iam_obj.mana_modpw(@tc_passwd, @tc_newpw, @tc_man_name)
      assert_equal(@ts_add_rs, rs["result"], "修改管理员密码失败!")
    }

    operate("4、使用新密码登录：") {
      rs = @iam_obj.manager_login(@tc_man_name, @tc_newpw)
      assert_equal(@ts_add_rs, rs["result"], "修改管理员后，使用新密码登录失败!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
