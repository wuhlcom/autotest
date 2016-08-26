#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_081", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "13444444245"
    @tc_nickname = "phone_mana"
    @tc_add_pw   = "123456"
    @tc_mod_pw1  = ""
  end

  def process

    operate("1��SSH��¼IAMϵͳ��") {
    }

    operate("2����ȡ�ֻ���֤�룻") {
    }

    operate("3������������Ϊ�գ�") {
      @iam_obj.del_manager(@tc_man_name)
      puts "ԭ����Ϊ#{@tc_add_pw},�޸�����Ϊ��".to_gbk
      rs = @iam_obj.mobile_manager_modpw(@tc_man_name, @tc_mod_pw1, @tc_add_pw, @tc_nickname)
      puts "RESULT err_msg:'#{rs['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_pwerr_msg, rs["err_msg"], "�޸�����Ϊ�շ��ش�����Ϣ����ȷ!")
      assert_equal(@ts_err_pwerr_code, rs["err_code"], "�޸�����Ϊ�շ��ش���code����ȷ!")
      assert_equal(@ts_err_pwerr_desc, rs["err_desc"], "�޸�����Ϊ�շ��ش���desc����ȷ!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
