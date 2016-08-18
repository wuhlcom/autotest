#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_079", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "13444444445"
    @tc_nickname = "phone_manager"
    @tc_add_pw   = "123456"
    @tc_mod_pw1  = "456789"
    @tc_mod_pw2  = "0123456789"*3+"22"
    @tc_mod_pw3  = "1234_abcd"
  end

  def process

    operate("1��SSH��¼IAMϵͳ��") {
    }

    operate("2����ȡ�ֻ���֤�룻") {
    }
    # mobile_manager_modpw(phone, mod_pw, add_pw="123456", nickname="autotest", url=MANAGER_MODPW_MOB_URL)
    operate("3�����������루����������Χ��ʽ��ȷ����") {
      @iam_obj.del_manager(@tc_man_name)
      puts "ԭ����Ϊ#{@tc_add_pw},�޸�����Ϊ#{@tc_mod_pw1},���볤��#{@tc_mod_pw1.size}".to_gbk
      rs_mod1 = @iam_obj.mobile_manager_modpw(@tc_man_name, @tc_mod_pw1, @tc_add_pw, @tc_nickname)
      puts "RESULT:#{rs_mod1}".encode("GBK")
      assert_equal(@ts_add_rs, rs_mod1["result"], "�޸��ֻ��˻���������Ա����ʧ��!")


      puts "�޸�����Ϊ#{@tc_mod_pw2},���볤��#{@tc_mod_pw2.size}".to_gbk
      rs_mod2 =@iam_obj.manager_modpw_mobile(@tc_man_name, @tc_mod_pw2)
      puts "RESULT:#{rs_mod2}".encode("GBK")
      assert_equal(@ts_add_rs, rs_mod2["result"], "�޸��ֻ��˻���������Ա����Ϊ#{@tc_mod_pw2}ʧ��!")

      rs_rlogin2 = @iam_obj.manager_login(@tc_man_name, @tc_mod_pw2)
      assert_equal(@ts_admin_log_rs, rs_rlogin2["result"], "�޸Ĺ���Ա����Ϊ#{@tc_mod_pw2}���¼ʧ��!")
      puts "RESULT name:#{rs_rlogin2['name']}".encode("GBK")
      assert_equal(@tc_man_name, rs_rlogin2["name"], "�޸Ĺ���Ա����Ϊ#{@tc_mod_pw2}���¼����name��Ϣ����!")
      puts "RESULT nickname:#{rs_rlogin2['nickname']}".encode("GBK")
      assert_equal(@tc_nickname, rs_rlogin2["nickname"], "�޸Ĺ���Ա����Ϊ#{@tc_mod_pw2}���¼����nickname��Ϣ����!")
################################################################################
      puts "�޸�����Ϊ#{@tc_mod_pw3},���볤��#{@tc_mod_pw3.size}".to_gbk
      rs_mod3=@iam_obj.manager_modpw_mobile(@tc_man_name, @tc_mod_pw3)
      puts "RESULT:#{rs_mod3}".encode("GBK")
      assert_equal(@ts_add_rs, rs_mod3["result"], "�޸��ֻ��˻���������Ա����Ϊ#{@tc_mod_pw3}ʧ��!")

      rs_rlogin3 = @iam_obj.manager_login(@tc_man_name, @tc_mod_pw3)
      assert_equal(@ts_admin_log_rs, rs_rlogin3["result"], "�޸��ֻ��˻���������Ա����Ϊ#{@tc_mod_pw3}ʧ��!!")
      puts "RESULT name:#{rs_rlogin3['name']}".encode("GBK")
      assert_equal(@tc_man_name, rs_rlogin3["name"], "�޸Ĺ���Ա����Ϊ#{@tc_mod_pw2}���¼����name��Ϣ����!")
      puts "RESULT nickname:#{rs_rlogin3['nickname']}".encode("GBK")
      assert_equal(@tc_nickname, rs_rlogin3["nickname"], "�޸Ĺ���Ա����Ϊ#{@tc_mod_pw3}���¼����nickname��Ϣ����!!")

    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
