#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_032", "level" => "P1", "auto" => "n"}

  def prepare

    @tc_args      =[]
    @tc_provider  = "wo"
    @tc_comments  = "autotest"
    @tc_app_name1 = "我要被修改了"
    param_part    = {provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args1     ={name: @tc_app_name1, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}

    @tc_args<<@tc_args1
    @tc_new_appname = "你我他niwotah"*3+"ai"
    @tc_new_appnames= ["z", @tc_new_appname, "魔鬼经济_01ABc"]
    @tc_new_appnames.each do |appname|
      param_name = {"name": appname}
      args       = param_part.merge(param_name)
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

    operate("3、获取修改应用的应用ID号;") {
    }

    operate("4、修改应用名称；") {
      puts "创建应用名为'#{@tc_app_name1}'".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")

      @tc_args.each_with_index do |args, index|
        next if index==0
        appname     = @tc_args[index-1][:name]
        new_appname = args[:name]
        tip         = "应用名由'#{appname}'======>修改为'#{new_appname}'"
        puts tip.to_gbk
        puts "新应用名长度为#{new_appname.size}".to_gbk
        rs = @iam_obj.mod_app(appname, @token, @admin_id, args)
        assert_equal(@ts_admin_log_rs, rs["result"], "#{tip}失败!")
        assert_equal(@ts_msg_ok, rs["msg"], "#{tip}失败!")
      end

    }


  end

  def clearup
    operate("1.恢复默认设置") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
      @tc_args.each do |args|
        appname = args[:name]
        puts "删除应用'#{appname}'".to_gbk
        @iam_obj.del_apply(appname, @token, @admin_id)
        # @iam_obj.mana_del_app(appname)
      end
    }
  end

}
