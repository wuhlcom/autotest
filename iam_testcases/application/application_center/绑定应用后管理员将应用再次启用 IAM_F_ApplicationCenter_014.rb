#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_ApplicationCenter_014", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_phone_usr    = "13700004444"
    @tc_usr_pw       = "123456"
    @tc_usr_regargs  = {type: "account", cond: @tc_phone_usr}
    @tc_app_name1    = "application1"
    @tc_app_provider = "zhilutest"
    @tc_app_comments = ""
    @tc_args1        = {name: @tc_app_name1, provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}

  end

  def process

    operate("1、ssh登录服务器；") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")
    }

    operate("2、知路管理员禁用该应用；") {
      rs     = @iam_obj.manager_login
      @uid   = rs["uid"]
      @token = rs["token"]
      rs     = @iam_obj.qc_app(@tc_args1[:name], @token, @uid, @tc_args1, "1")
      tip    = "创建并激活应用‘#{@tc_args1[:name]}’"
      puts tip.to_gbk
      assert_equal(@ts_add_rs, rs["result"], "#{tip}失败")

      #绑定
      @rs = @iam_obj.usr_qb_app(@tc_phone_usr, @tc_usr_pw, @tc_app_name1)
      assert_equal(@ts_add_rs, @rs["result"], "用户绑定应用失败")

      #查询
      rs3 = @iam_obj.usr_login_list_app_bytype(@tc_phone_usr, @tc_usr_pw, @tc_app_name1, false)
      assert_equal(@tc_app_name1, rs3["apps"][0]["name"], "绑定应用后，不可以查询到应用")

      #禁用
      @iam_obj.qc_app(@tc_args1[:name], @token, @uid, @tc_args1, "0")
      assert_equal(1, @rs["result"], "应用#{@tc_args1[:name]}禁用失败")
    }

    operate("3、用户查询我的应用；") {
      rs3 = @iam_obj.usr_login_list_app_bytype(@tc_phone_usr, @tc_usr_pw, @tc_app_name1, false)
      assert_equal("0", rs3["totalRows"], "禁用应用后，可以查询到应用")
    }

    operate("4、知路管理员再次启用该应用；") {
      #再次激活
      @iam_obj.get_client_active_app(@tc_app_name1, @token, @uid, "1")
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
      @iam_obj.mana_del_app(@tc_usr_names)
    }
  end

}
