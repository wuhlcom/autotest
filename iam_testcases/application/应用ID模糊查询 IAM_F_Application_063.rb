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

    operate("1、ssh登录IAM服务器；") {
      @res = @iam_obj.manager_login #管理员登录->得到uid和token
      assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
    }

    operate("2、获取知路管理员token值；") {
      @admin_id    = @res["uid"]
      @admin_token = @res["token"]
    }

    operate("3、按应用ID模糊查询;") {
      @tc_id_conds.each do |cond|
        args = {"type" => "id", "cond" => cond}
        rs   = @iam_obj.get_app_list(@admin_token, @admin_id, args)
        refute_empty(rs["apps"], "按应用ID模糊查询，未查询到数据！")
        flag = rs["apps"].any? { |client| client.has_value?(@ts_app_id_001) }
        assert(flag, "按应用ID模糊查询失败，未查询到数据！")
      end
    }
  end

  def clearup
    operate("1.恢复默认设置") {

    }
  end
}
