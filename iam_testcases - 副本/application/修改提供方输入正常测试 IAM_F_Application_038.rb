#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_038", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_args      =[]
    @tc_provider  = "zhilutec"
    @tc_comments  = "autotest"
    @tc_app_name1 = "西兰花"
    param_part    = {name: @tc_app_name1, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args1     = {name: @tc_app_name1, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args<<@tc_args1

    @tc_new_pro = "你我他niwotah"*3+"ai"
    @tc_new_pros= ["x", @tc_new_pro, "魔鬼经济_01ABc"]
    @tc_new_pros.each do |provider|
      param_pro = {provider: provider}
      args      = param_part.merge(param_pro)
      @tc_args<<args
    end

  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理员token值；") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("3、获取修改应用的ID号;") {
      puts "创建应用名为'#{@tc_app_name1}'".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")
    }

    operate("4、修改provider为正常值；") {
      @tc_args.each_with_index do |args, index|
        next if index==0
        pro_name = @tc_args[index-1][:provider]
        new_pro  = args[:provider]
        tip      = "应用提供方由'#{pro_name}'======>修改为'#{new_pro}'"
        puts tip.to_gbk
        puts "新应用提供方长度为#{new_pro.size}".to_gbk
        rs = @iam_obj.mod_app(pro_name, @token, @admin_id, args)
        assert_equal(@ts_admin_log_rs, rs["result"], "#{tip}失败!")
        assert_equal(@ts_msg_ok, rs["msg"], "#{tip}失败!")
      end
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
