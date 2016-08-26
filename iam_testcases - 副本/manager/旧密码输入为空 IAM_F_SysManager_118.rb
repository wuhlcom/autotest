#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_118", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "autotest_001@zhilutec.com"
    @tc_nickname = "autotest_whl"
    @tc_passwd   = "123456"
    @tc_old_pw   = ""
    @tc_new_pw   = "12345678"
  end

  def process

    operate("1��ssh��¼IAM��������") {
      #��ӹ���Ա
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Աʧ��!")
    }

    operate("2����ȡ֪·����Աid��tokenֵ��") {
    }

    operate("3������������Ϊ�գ�") {
      # @iam_obj.mana_modpw(@tc_old_pw, @tc_new_pw, @tc_man_name) #���ܵ��ô˽ӿ�,�˽ӿ�ʹ��ǰ���ǹ�������¼�ɹ�
      rs     = @iam_obj.manager_login(@tc_man_name, @tc_passwd)
      uid    = rs["uid"]
      token  = rs["token"]
      tip    = "����������Ϊ��"
      rs_mod = @iam_obj.manager_modpw(@tc_old_pw, @tc_new_pw, uid, token)
      puts "RESULT err_msg:#{rs_mod['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs_mod['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs_mod['err_desc']}".encode("GBK")
      assert_equal(@ts_err_oldpw_code, rs_mod["err_code"], "#{tip}��ʾcode����!")
      assert_equal(@ts_err_oldpw_msg, rs_mod["err_msg"], "#{tip}��ʾmsg����!")
      assert_equal(@ts_err_oldpw_desc, rs_mod["err_desc"], "#{tip}��ʾdesc����!")
    }

  end

  def clearup

    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }

  end

}
