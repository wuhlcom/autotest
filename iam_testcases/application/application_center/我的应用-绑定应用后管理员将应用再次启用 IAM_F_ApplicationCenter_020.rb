#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_ApplicationCenter_020", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13734104444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}

    @tc_app_name1    = "whlfeifei1"
    @tc_app_provider = "zhilutest"
    @tc_app_comments = "whl"
    @tc_app_args     ={name: @tc_app_name1, provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}
  end

  def process

    operate("1、ssh登录服务器；") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")
      
      @rs1 = @iam_obj.qca_app(@tc_app_name1, @tc_app_args, "1")
      assert_equal(1, @rs1["result"], "创建应用1失败")
    }

    operate("2、知路管理员禁用该应用；") {
      @rss1 = @iam_obj.usr_qb_app(@tc_phone_usr, @tc_usr_pw, @tc_app_name1)
      assert_equal(1, @rss1["result"], "用户绑定应用1失败")
    }

    operate("3、用户查询我的应用；") {
      @rs = @iam_obj.mana_active_app(@tc_app_name1, "0")
      assert_equal(1, @rs["result"], "应用1禁用失败")

      rs3 = @iam_obj.usr_login_list_app_bytype(@tc_phone_usr, @tc_usr_pw, @tc_app_name1, false)
      assert_equal("0", rs3["totalRows"], "禁用应用后，可以查询到应用")
    }

    operate("4、知路管理员再次启用该应用；") {
      @rs = @iam_obj.mana_active_app(@tc_app_name1, "1")
      assert_equal(1, @rs["result"], "应用1启用失败")
    }

    operate("5、用户查询我的应用；") {
      rs3 = @iam_obj.usr_login_list_app_bytype(@tc_phone_usr, @tc_usr_pw, @tc_app_name1, false)
      assert_equal(@tc_app_name1, rs3["apps"][0]["name"], "启用应用后，不可以查询到应用")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
