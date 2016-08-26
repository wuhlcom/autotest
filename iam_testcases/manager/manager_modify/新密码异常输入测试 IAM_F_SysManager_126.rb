#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_126", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_man_name = "zlautotest2@zhilutec.com"
    @tc_nickname = "知路测试"
    @tc_passwd   = "zhilutec"
    @tc_newpw1   = "中国中国中国"
    @tc_newpw2   = "１２３４５６"
    @tc_newpw3   = "abcd()_+#@%^"
    @tc_newpws   = [@tc_newpw1, @tc_newpw2, @tc_newpw3]
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      #添加管理员
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "添加超级管理员失败!")
    }

    operate("2、获取知路管理员id和token值；") {
    }

    operate("3、修改新密码为异常输入；") {
      rs_login = @iam_obj.manager_login(@tc_man_name, @tc_passwd)
      assert_equal(@ts_add_rs, rs_login["result"], "超级管理员登录失败!")
      uid   = rs_login["uid"]
      token = rs_login["token"]
      @tc_newpws.each_with_index do |passwd, index|
        tip = "密码由'#{@tc_passwd}'修改为'#{passwd}'"
        puts tip.to_gbk
        puts "新密码'#{passwd}'长度为#{passwd.size}".to_gbk
        rs = @iam_obj.manager_modpw(@tc_passwd, passwd, uid, token)
        puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
        puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
        puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
        assert_equal(@ts_err_pwformat_code, rs["err_code"], "#{tip}提示code错误!")
        assert_equal(@ts_err_pwformat, rs["err_msg"], "#{tip}提示msg错误!")
        assert_equal(@ts_err_pwformat_desc, rs["err_desc"], "#{tip}提示desc错误!")
      end
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
