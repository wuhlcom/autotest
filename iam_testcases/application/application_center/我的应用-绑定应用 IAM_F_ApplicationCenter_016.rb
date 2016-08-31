#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_ApplicationCenter_016", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_phone_usr    = "13734144444"
    @tc_usr_pw       = "123456"
    @tc_usr_regargs  = {type: "account", cond: @tc_phone_usr}

    @tc_app_name1    = "lication4"
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

    operate("2、获取应用的ID号；") {

    }

    operate("3、获取登录用户的token值和id号；") {
    }

    operate("4、用户绑定应用；") {
      @rss1 = @iam_obj.usr_qb_app(@tc_phone_usr, @tc_usr_pw, @tc_app_name1)
      assert_equal(1, @rss1["result"], "用户绑定应用1失败")
    }
  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
