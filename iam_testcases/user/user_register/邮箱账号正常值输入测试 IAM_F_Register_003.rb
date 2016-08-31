#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Register_003", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_user_name_163     = "autotest@163.com"
    @tc_user_name_qq      = "2578915468@qq.com"
    @tc_user_name_126     = "autotest@126.com"
    @tc_user_name_sina    = "autotest@sina.com"
    @tc_user_name_sohu    = "autotest@sohu.com"
    @tc_user_name_yahoo   = "autotest@yahoo.com"
    @tc_user_name_gmail   = "autotest@gmail.com"
    @tc_user_name_hotmail = "autotest@hotmail.com"
    @tc_user_name_32      = "zhilukeji1zhilukeji@sohu.com"
    @tc_user_name_ul      = "zhilu123_123@126.com"
    @tc_usr_emails        =[@tc_user_name_163, @tc_user_name_qq, @tc_user_name_126, @tc_user_name_sina, @tc_user_name_sohu, @tc_user_name_yahoo, @tc_user_name_gmail, @tc_user_name_hotmail, @tc_user_name_32, @tc_user_name_ul]
    @tc_user_pwd          = "123123"
  end

  def process

    operate("1、ssh登录IAM服务器；") {

    }

    operate("2、使用邮箱注册用户；（使用不同的邮箱进行测试）") {
      @tc_usr_emails.each do |email|
        tip = "使用邮箱'#{email}'注册用户"
        puts tip.to_gbk
        rs1 = @iam_obj.register_emailusr(email, @tc_user_pwd, 1)
        assert_equal(1, rs1["result"], "#{tip}失败")
      end
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @tc_usr_emails.each do |email|
        tip = "删除邮箱用户'#{email}'"
        puts tip.to_gbk
        @iam_obj.usr_delete_usr(email, @tc_user_pwd)
      end
    }
  end

}
