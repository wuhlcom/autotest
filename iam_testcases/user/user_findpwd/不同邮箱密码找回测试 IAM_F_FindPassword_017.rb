#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_FindPassword_017", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_email_usr   = %w(2194938072@qq.com gaohui@zhilutec.com auto001@163.com auto002@126.com auto003@sina.com.cn auto003@sohu.com auto004@yahoo.com.cn auto004@gmail.com auto005@hotmail.com)
    @tc_usr_pwd     = "123456"
    @tc_usr_pwd_new = "123123"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      @tc_email_usr.each do |email|
        tip = "注册邮箱用户'#{email}'"
        puts tip.to_gbk
        rs = @iam_obj.register_emailusr(email, @tc_usr_pwd, 1)
        assert_equal(1, rs["result"], "#{tip}失败")
        rs2  = @iam_obj.user_login(email, @tc_usr_pwd)
        tip1 = "邮箱用户'#{email}'注册后登录"
        puts tip1.to_gbk
        assert_equal(1, rs2["result"], "#{tip1}失败")
      end
    }

    operate("2、使用不同邮箱进行注册用户，然后进行密码找回测试；如qq邮箱") {

    }

    operate("3、密码修改；") {
      @tc_email_usr.each do |email|
        tip = "邮箱用户'#{email}'找回密码"
        puts tip.to_gbk
        rs1 = @iam_obj.usr_find_mod_emailpw(email, @tc_usr_pwd_new)
        assert_equal(1, rs1["result"], "#{tip}失败")
        tip1 = "邮箱用户'#{email}'找回密码后使用新密码登录"
        puts tip1.to_gbk
        rs2= @iam_obj.user_login(email, @tc_usr_pwd_new)
        assert_equal(1, rs2["result"], "#{tip1}失败")
      end

    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @tc_email_usr.each do |email|
        tip = "删除邮箱用户'#{email}'"
        puts tip.to_gbk
        @iam_obj.usr_delete_usr(email, @tc_usr_pwd)
        @iam_obj.usr_delete_usr(email, @tc_usr_pwd_new)
      end
    }
  end

}
