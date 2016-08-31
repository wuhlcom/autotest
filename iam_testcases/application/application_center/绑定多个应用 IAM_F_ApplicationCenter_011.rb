#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_ApplicationCenter_011", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_app_name1    = "application1"
    @tc_app_name2    = "application12"
    @tc_app_name3    = "app3"
    @tc_app_name4    = "lication4"
    @tc_app_provider = "zhilutest"
    @tc_app_comments = ""
    @tc_app_names_part      = [@tc_app_name2, @tc_app_name3, @tc_app_name4]
    @tc_app_names    = @tc_app_names_part.unshift(@tc_app_name1)
    @tc_usr_part     = {provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}
    @tc_usr_args     = []
    @tc_app_names.each do |tc_usr_name|
      args = {name: tc_usr_name}
      args = args.merge(@tc_usr_part)
      @tc_usr_args<<args
    end
  end

  def process

    operate("1、ssh登录服务器；") {
      rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@ts_phone_usr}注册失败")
    }

    operate("2、获取应用的ID号；") {
      rs    = @iam_obj.manager_login
      uid   = rs["uid"]
      token = rs["token"]
      @tc_usr_args.each do |args|
        rs  = @iam_obj.qc_app(args[:name], token, uid, args, "1")
        tip = "创建并激活应用‘#{args[:name]}’"
        puts tip.to_gbk
        assert_equal(@ts_add_rs, rs["result"], "#{tip}失败")
      end
    }

    operate("3、获取登录用户的token值和id号；") {
    }

    operate("4、用户绑定应用；") {
      rs_login = @iam_obj.user_login(@ts_phone_usr, @ts_usr_pw)
      usrid    =rs_login["uid"]
      token    =rs_login["access_token"]
      rs1      = @iam_obj.qb_app(@tc_app_name1, usrid, token)
      assert_equal(@ts_add_rs, rs1["result"], "用户绑定应用#{@tc_app_name1}失败")

      rs2 = @iam_obj.qb_app(@tc_app_names_part, usrid, token)
      assert_equal(@ts_add_rs, rs2["result"], "用户绑定应用#{@tc_app_name1}失败")
    }
  end

  def clearup

    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
      @iam_obj.mana_del_app(@tc_app_names)
    }
  end
}
