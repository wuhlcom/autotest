#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_109", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "mtest@zhilutec.com"
    @tc_nickname = "������"
    @tc_passwd   = "zhilutec"
    @tc_args     = {"nickname" => "���ű�", "comments" => "���ű������������ı�"}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����Աtokenֵ��id�ţ�") {
      #�������Ա�Ѿ���������ɾ��
      @iam_obj.del_manager(@tc_man_name)
      puts "��������Ա:��#{@tc_man_name}��".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "���ϵͳ����Աʧ��!")
      assert_equal(@ts_add_msg, rs["msg"], "���ϵͳ����Աʧ��!")
    }

    operate("3������Ա�޸�������Ϣ��") {
      rs = @iam_obj.edit_mana_info(@tc_args, @tc_man_name, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "ϵͳ����Ա�޸���Ϣʧ��!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
