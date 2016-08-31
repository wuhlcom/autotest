#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_ApplicationCenter_010", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_phone_usr    = "13700004444"
    @tc_usr_pw       = "123456"
    @tc_usr_regargs  = {type: "account", cond: @tc_phone_usr}
    @tc_app_name1    = "application1"
    @tc_app_name2    = "application12"
    @tc_app_name3    = "app3"
    @tc_app_name4    = "lication4"
    @tc_app_provider = "zhilutest"
    @tc_app_comments = ""
    @tc_app_names    = [@tc_app_name1, @tc_app_name2, @tc_app_name3, @tc_app_name4]
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
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")
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
     @rs = @iam_obj.usr_qb_app(@tc_phone_usr, @ts_usr_pw, @tc_app_name1)
      assert_equal(@ts_add_rs, @rs["result"], "用户绑定应用失败")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_names)
    }
  end

}
