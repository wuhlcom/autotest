#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_060", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_man_name   = "zlautotest3@zhilutec.com"
    @tc_nickname   = "֪·����"
    @tc_passwd     = "zhilutec"
    @tc_man_nulname= ""
  end

  def process

    operate("1��ssh��¼IAM��������") {
      #��ӹ���Ա
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Աʧ��!")
    }

    operate("2������Ա��¼���˺�����Ϊ�գ�") {
      tip = "�������˺�ֻ���������¼"
      rs = @iam_obj.manager_login(@tc_man_nulname, @tc_passwd)
      # {"err_code"=>"10001", "err_msg"=>"\u5E10\u53F7\u6216\u5BC6\u7801\u9519\u8BEF", "err_desc"=>"E_USER_PWD_ERROR"}
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_login_code, rs["err_code"], "#{tip}���ش����벻��ȷ!")
      assert_equal(@ts_err_login, rs["err_msg"], "#{tip}������Ϣ����ȷ!")
      assert_equal(@ts_err_login_desc, rs["err_desc"], "#{tip}������������ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {

    }
  end

}
