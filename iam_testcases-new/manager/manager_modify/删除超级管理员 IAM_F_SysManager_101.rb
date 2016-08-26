#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_101", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_account = "klwn20@163.com" #����Ϊ��ʵ��Ч������
    @tc_passwd  = "1222267"
    @tc_nickname= "pilipili"
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ֪·����tokenֵ��") {
      #�����˻�
      rs_login = @iam_obj.manager_add_login(@tc_account, @tc_passwd, @tc_nickname)
      assert_equal(@ts_admin_log_rs, rs_login["result"], "�����˻�#{@tc_account}ʧ��!")
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

    }
  end

}
