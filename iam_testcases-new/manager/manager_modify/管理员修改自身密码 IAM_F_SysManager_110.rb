#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_110", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "w2test@zhilutec.com"
    @tc_nickname = "����"
    @tc_passwd   = "zhilutec"
    @tc_newpw    = "123456"
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ����Աtokenֵ��id�ţ�") {
      #�������Ա�Ѿ���������ɾ��
      @iam_obj.del_manager(@tc_man_name)
      puts "��������Ա:��#{@tc_man_name}��".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "���ϵͳ����Աʧ��!")
      assert_equal(@ts_add_msg, rs["msg"], "���ϵͳ����Աʧ��!")
    }

    operate("3���޸����룺") {
      rs = @iam_obj.mana_modpw(@tc_passwd, @tc_newpw, @tc_man_name)
      assert_equal(@ts_add_rs, rs["result"], "�޸Ĺ���Ա����ʧ��!")
    }

    operate("4��ʹ���������¼��") {
      rs = @iam_obj.manager_login(@tc_man_name, @tc_newpw)
      assert_equal(@ts_add_rs, rs["result"], "�޸Ĺ���Ա��ʹ���������¼ʧ��!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
