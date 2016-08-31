#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_UserView_008", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13701424444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}
  end

  def process

    operate("1��ssh��¼IAM��������") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")

      @res         = @iam_obj.manager_login #����Ա��¼->�õ�uid��token
      @admin_id    = @res["uid"]
      @admin_token = @res["token"]
    }

    operate("2����ȡ֪·����Աtokenֵ��") {

    }

    operate("3����ȡ�û�id��") {
      rs = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
      @usr_id = rs["uid"]
    }

    operate("4����ѯĳ���û�����") {
      p rs = @iam_obj.get_user_details(@admin_id, @admin_token, @usr_id)
      assert_equal(@tc_phone_usr, rs["account"], "��ѯ�û���ϸ��Ϣ���˻���Ϣʧ��")
      assert_equal(@usr_id, rs["id"], "��ѯ�û���ϸ��Ϣ�û�idʧ��")
      assert_nil(rs["name"], "��ѯ�û���ϸ��Ϣ�û�nameʧ��")
      assert_nil(rs["sex"], "��ѯ�û���ϸ��Ϣ�û�sexʧ��")
      assert_nil(rs["qq"], "��ѯ�û���ϸ��Ϣ�û�qqʧ��")
      assert_nil(rs["mobile"], "��ѯ�û���ϸ��Ϣ�û�mobileʧ��")
      assert_nil(rs["email"], "��ѯ�û���ϸ��Ϣ�û�mobileʧ��")
      assert_empty(rs["apps"], "��ѯ�û���ϸ��Ϣ�û�mobileʧ��")
    }
  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
    }
  end

}
