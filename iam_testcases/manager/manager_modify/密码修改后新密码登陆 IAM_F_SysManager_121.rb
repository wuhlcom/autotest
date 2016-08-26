#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_121", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_man_name = "w3test@zhilutec.com"
    @tc_nickname = "桃树"
    @tc_passwd   = "zhilutec"
    @tc_newpw    = "123456"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      #添加管理员
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "添加超级管理员失败!")
    }

    operate("2、获取知路管理员id和token值；") {
    }

    operate("3、修改新密码；") {
      rs = @iam_obj.mana_modpw(@tc_passwd, @tc_newpw, @tc_man_name)
      assert_equal(@ts_add_rs, rs["result"], "修改管理员密码失败!")
    }

    operate("4、使用新密码登录；") {
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
