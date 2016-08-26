#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_104", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_account = "klwn20@163.com" #����Ϊ��ʵ��Ч������
    @tc_passwd  = "12222627"
    @tc_nickname= "pilipili"
    @tc_rcode   = "5"
  end

  def process

    operate("1��ssh��¼IAM��������") {
      #�����˻�
      rs_login = @iam_obj.manager_del_add(@tc_account, @tc_passwd, @tc_nickname, @tc_rcode)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "�����˻�#{@tc_account}ʧ��!")
    }

    operate("2����ȡ֪·����tokenֵ��") {
    }

    operate("3����ȡ����Ա�б�͹���Աuerid�ţ�") {
    }

    operate("4��ɾ��ָ���Ĺ���Ա��") {
      p rs= @iam_obj.del_manager(@tc_account)
      assert_equal(@ts_admin_log_rs, rs["result"], "�����˻�#{@tc_account}ʧ��!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_account)
    }
  end

}
