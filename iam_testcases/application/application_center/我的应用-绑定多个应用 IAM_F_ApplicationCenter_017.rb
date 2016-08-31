#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_ApplicationCenter_017", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13734044444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}

    @tc_app_name1    = "whlapp1"
    @tc_app_name2    = "whlapp2"
    @tc_app_name3    = "whlapp3"
    @tc_app_name4    = "whlapp4"
    @tc_app_provider = "zhilutest"
    @tc_app_comments = "whl"
    @tc_app_name_arr = [@tc_app_name2, @tc_app_name3, @tc_app_name4]

    @tc_app_names =@tc_app_name_arr.unshift(@tc_app_name1)
    @tc_app_part  ={provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}
    @tc_app_infos = []
    @tc_app_names.each do |appname|
      args1 = {name: appname}
      args  = args1.merge(@tc_app_part)
      @tc_app_infos<<args
    end
  end

  def process

    operate("1、ssh登录服务器；") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")

      rs2    = @iam_obj.manager_login()
      @uid   = rs2["uid"]
      @token = rs2["token"]

      @tc_app_infos.each do |app|
        tip ="创建应用'#{app[:name]}'"
        rs3 = @iam_obj.qc_app(app[:name], @token, @uid, app, "1")
        assert_equal(1, rs3["result"], "#{tip}失败")
      end
    }

    operate("2、获取应用的ID号；") {
      @rss1 = @iam_obj.usr_qb_app(@tc_phone_usr, @tc_usr_pw, @tc_app_name1)
      assert_equal(1, @rss1["result"], "用户绑定应用1失败")

      @rs = @iam_obj.usr_qb_app(@tc_phone_usr, @tc_usr_pw, @tc_app_name_arr)
      assert_equal(1, @rs["result"], "用户批量绑定应用失败")
    }

    operate("3、获取登录用户的token值和id号；") {
    }

    operate("4、用户绑定应用；") {
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_names)
    }
  end

}
