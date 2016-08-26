#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_122", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_man_name = "w4test@zhilutec.com"
    @tc_nickname = "֪·����"
    @tc_passwd   = "zhilutec"
    @tc_newpw    = "123456"
  end

  def process

    operate("1��ssh��¼IAM��������") {
      #��ӹ���Ա
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Աʧ��!")

      rs = @iam_obj.mana_modpw(@tc_passwd, @tc_newpw, @tc_man_name)
      assert_equal(@ts_add_rs, rs["result"], "�޸Ĺ���Ա����ʧ��!")
    }

    operate("2��ʹ�þ������¼��") {
      tip = "ʹ�þ������¼"
      rs = @iam_obj.manager_login(@tc_man_name, @tc_passwd)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_login_code, rs["err_code"], "#{tip}��ʾcode����!")
      assert_equal(@ts_err_login, rs["err_msg"], "#{tip}��ʾmsg����!")
      assert_equal(@ts_err_login_desc, rs["err_desc"], "#{tip}��ʾdesc����!")
    }

  end

  def clearup

    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
