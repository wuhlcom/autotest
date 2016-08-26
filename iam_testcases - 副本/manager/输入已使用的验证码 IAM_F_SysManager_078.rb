#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_078", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name    = "13566600000"
    @tc_add_passwd  = "123456"
    @tc_mod_passwd1 = "12345678"
    @tc_mod_passwd2 = "123456789"
    @tc_nickname    = "hahawangle"

  end

  def process

    operate("1��SSH��¼IAMϵͳ��") {
    }

    operate("2����ȡ�ֻ���֤�룻") {
      #������ֻ�����Ա
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_add_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "��ӹ���Ա#{@tc_man_name}ʧ��!")
    }

    operate("3�����������롢��֤����ʹ�ã�") {
      #������֤��
      rs_recode = @iam_obj.request_mobile_code(@tc_man_name)
      puts "�������֤��Ϊ#{rs_recode["code"]}".to_gbk
      #��ȡ��֤��
      rs_getcode= @iam_obj.get_mobile_code(@tc_man_name)
      puts "��ȡ����֤��#{rs_getcode["code"]}".to_gbk
      rs_rlogin1 = @iam_obj.manager_login(@tc_man_name, @tc_mod_pw1)
      #�һ��ֻ�����
      puts "��֤��#{rs_getcode["code"]}�һ�����".to_gbk
      rs         = @iam_obj.phone_manager_modpw(@tc_man_name, @tc_mod_passwd1, rs_getcode["code"])
      assert_equal(@ts_admin_log_rs, rs["result"], "�޸Ĺ���Ա����Ϊ#{@tc_mod_pw1}ʧ��!")


      #ʹ����ͬ����֤�����һ�һ���ֻ�����
      puts "��һ��ʹ����֤��#{rs_getcode["code"]}�һ�����".to_gbk
      rs = @iam_obj.phone_manager_modpw(@tc_man_name, @tc_mod_passwd2, rs_getcode["code"])
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_pcodnul_msg, rs["err_msg"], "���뱻ʹ�ù�����֤�뷵�ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_pcodnul_code, rs["err_code"], "���뱻ʹ�ù�����֤�뷵�ش���code����ȷ!")
      assert_equal(@ts_err_pcodnul_desc, rs["err_desc"], "���뱻ʹ�ù�����֤�뷵�ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {

    }
  end

}
