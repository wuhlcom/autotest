#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_062", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_appname = "wuhl_3452"
    @tc_args    = {name: @tc_appname, provider: "provider", redirect_uri: @ts_app_redirect_uri, comments: "autotest"}
    @tc_cond1   = "wuhl"
    @tc_cond2   = "3452"
    @tc_cond3   = "hl_34"
    @tc_conds   = [@tc_cond1, @tc_cond2, @tc_cond3]
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      @res = @iam_obj.manager_login #管理员登录->得到uid和token
      assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
    }

    operate("2、获取知路管理员token值；") {
      @admin_id    = @res["uid"]
      @admin_token = @res["token"]
      rs           = @iam_obj.qc_app(@tc_appname, @admin_token, @admin_id, @tc_args)
      assert_equal(@ts_add_rs, rs["result"], "按应用名称模糊查询失败，未查询到数据！")
    }

    operate("3、按应用名称模糊查询;") {
      @tc_conds.each do |cond|
        args = {"type" => "name", "cond" => cond}
        rs   = @iam_obj.get_app_list(@admin_token, @admin_id, args)
        refute_empty(rs["apps"], "按应用名称模糊查询失败，未查询到数据！")
        assert_equal(rs["apps"][0]["name"], @tc_appname, "按应用名称模糊查询失败，未查询到数据！")
      end
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_appname)
    }
  end

}
