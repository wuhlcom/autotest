#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_121", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_man_name = "w3test@zhilutec.com"
    @tc_nickname = "����"
    @tc_passwd   = "zhilutec"
    @tc_newpw    = "123456"
  end

  def process

    operate("1��ssh��¼IAM��������") {
      #��ӹ���Ա
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Աʧ��!")
    }

    operate("2����ȡ֪·����Աid��tokenֵ��") {
    }

    operate("3���޸������룻") {
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
