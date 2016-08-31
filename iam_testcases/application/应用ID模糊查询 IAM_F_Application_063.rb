#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_063", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_id_cond1 = "1607"
    @tc_id_cond2 = "271260"
    @tc_id_cond3 = "27126008"
    @tc_id_conds = [@tc_id_cond1, @tc_id_cond2, @tc_id_cond3]
  end

  def process

    operate("1��ssh��¼IAM��������") {
      @res = @iam_obj.manager_login #����Ա��¼->�õ�uid��token
      assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
    }

    operate("2����ȡ֪·����Աtokenֵ��") {
      @admin_id    = @res["uid"]
      @admin_token = @res["token"]
    }

    operate("3����Ӧ��IDģ����ѯ;") {
      @tc_id_conds.each do |cond|
        args = {"type" => "id", "cond" => cond}
        rs   = @iam_obj.get_app_list(@admin_token, @admin_id, args)
        refute_empty(rs["apps"], "��Ӧ��IDģ����ѯ��δ��ѯ�����ݣ�")
        flag = rs["apps"].any? { |client| client.has_value?(@ts_app_id_001) }
        assert(flag, "��Ӧ��IDģ����ѯʧ�ܣ�δ��ѯ�����ݣ�")
      end
    }
  end

  def clearup
    operate("1.�ָ�Ĭ������") {

    }
  end
}
