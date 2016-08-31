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

    operate("1��ssh��¼IAM��������") {
      @tc_email_usr.each do |email|
        tip = "ע�������û�'#{email}'"
        puts tip.to_gbk
        rs = @iam_obj.register_emailusr(email, @tc_usr_pwd, 1)
        assert_equal(1, rs["result"], "#{tip}ʧ��")
        rs2  = @iam_obj.user_login(email, @tc_usr_pwd)
        tip1 = "�����û�'#{email}'ע����¼"
        puts tip1.to_gbk
        assert_equal(1, rs2["result"], "#{tip1}ʧ��")
      end
    }

    operate("2��ʹ�ò�ͬ�������ע���û���Ȼ����������һز��ԣ���qq����") {

    }

    operate("3�������޸ģ�") {
      @tc_email_usr.each do |email|
        tip = "�����û�'#{email}'�һ�����"
        puts tip.to_gbk
        rs1 = @iam_obj.usr_find_mod_emailpw(email, @tc_usr_pwd_new)
        assert_equal(1, rs1["result"], "#{tip}ʧ��")
        tip1 = "�����û�'#{email}'�һ������ʹ���������¼"
        puts tip1.to_gbk
        rs2= @iam_obj.user_login(email, @tc_usr_pwd_new)
        assert_equal(1, rs2["result"], "#{tip1}ʧ��")
      end

    }

  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @tc_email_usr.each do |email|
        tip = "ɾ�������û�'#{email}'"
        puts tip.to_gbk
        @iam_obj.usr_delete_usr(email, @tc_usr_pwd)
        @iam_obj.usr_delete_usr(email, @tc_usr_pwd_new)
      end
    }
  end

}
