#
# description:
# 两头空格会自动去除,但对于密码建议不去空格应该报错
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_128", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_man_name = "zlautotest3@zhilutec.com"
    @tc_nickname = "知路测试"
    @tc_passwd   = "zhilutec"
    @tc_newpw1   = " 123456"
    @tc_newpw2   = "1234567 "
    @tc_newpw3   = "123 456"
    @tc_newpws   = [@tc_passwd, @tc_newpw1, @tc_newpw2]
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      #添加管理员
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "添加超级管理员失败!")
    }

    operate("2、获取知路管理员id和token值；") {
    }

    operate("3、新密码输入带有空格；") {
      @tc_newpws.each_with_index do |passwd, index|
        next if index ==0
        oldpasswd= @tc_newpws[index-1]
        tip      = "密码由'#{oldpasswd}'修改为'#{passwd}'"
        puts tip.to_gbk
        puts "新密码'#{passwd}'长度为#{passwd.size}".to_gbk
        rs = @iam_obj.mana_modpw(oldpasswd, passwd, @tc_man_name)
        assert_equal(@ts_add_rs, rs["result"], "#{tip}失败!")
        rs = @iam_obj.manager_login(@tc_man_name, passwd)
        assert_equal(@ts_add_rs, rs["result"], "#{tip}登录失败!")
      end

      tip = "密码由'#{@tc_newpw2}'修改为'#{@tc_newpw3}'"
      puts tip.to_gbk
      puts "新密码'#{@tc_newpw3}'长度为#{@tc_newpw3.size}".to_gbk
      rs = @iam_obj.mana_modpw(@tc_newpw2, @tc_newpw3, @tc_man_name)
      # rs = @iam_obj.manager_modpw(passwd, @tc_newpw3, uid, token)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_pwformat_code, rs["err_code"], "#{tip}提示code错误!")
      assert_equal(@ts_err_pwformat, rs["err_msg"], "#{tip}提示msg错误!")
      assert_equal(@ts_err_pwformat_desc, rs["err_desc"], "#{tip}提示desc错误!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
