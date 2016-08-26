#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_123", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_man_name = "zltest@zhilutec.com"
    @tc_nickname = "知路测试"
    @tc_passwd   = "zhilutec"
    @tc_newpw1   = "123456"
    @tc_newpw2   = "012345678a"*3+"bb"
    @tc_newpw3   = "Zhilutec_123"
    @tc_newpws   = [@tc_passwd, @tc_newpw1, @tc_newpw2, @tc_newpw3]
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      #添加管理员
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "添加超级管理员失败!")
    }

    operate("2、获取知路管理员id和token值；") {
    }

    operate("3、修改新密码，输入值正常；") {
      @tc_newpws.each_with_index do |passwd, index|
        next if index ==0
        oldpasswd = @tc_newpws[index-1]
        tip       = "密码由'#{oldpasswd}'修改为'#{passwd}'"
        puts tip.to_gbk
        puts "新密码'#{passwd}'长度为#{passwd.size}".to_gbk
        rs = @iam_obj.mana_modpw(oldpasswd, passwd, @tc_man_name)
        assert_equal(@ts_add_rs, rs["result"], "#{tip}失败!")
        rs = @iam_obj.manager_login(@tc_man_name, passwd)
        assert_equal(@ts_add_rs, rs["result"], "#{tip}登录失败!")
      end
    }

  end

  def clearup

    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end


}
