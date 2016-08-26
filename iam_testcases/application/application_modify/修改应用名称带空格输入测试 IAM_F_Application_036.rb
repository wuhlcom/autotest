#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_036", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_args      =[]
    @tc_provider  = "wo"
    @tc_comments  = "autotest"
    @tc_app_name1 = "通天仙教"
    @tc_app_name2 = "鬼王 血宗"
    param_part    = {provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args1     ={name: @tc_app_name1, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args2     ={name: @tc_app_name2, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}

    @tc_args<<@tc_args1
    @tc_new_appnames= [" 冥月教", "黑魔门 "]
    @tc_new_appnames.each do |appname|
      param_name = {name: appname}
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
      puts "创建应用名为'#{@tc_app_name1}'".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")
    }

    operate("4、修改应用名称带空格；") {
      @tc_args.each_with_index do |args, index|
        next if index==0
        appname = @tc_args[index-1][:name]
        tip     = "应用名由'#{appname}'======>修改为'#{args[:name]}'"
        puts tip.to_gbk
        rs = @iam_obj.mod_app(appname, @token, @admin_id, args)
        assert_equal(@ts_admin_log_rs, rs["result"], "#{tip}失败!")
        assert_equal(@ts_msg_ok, rs["msg"], "#{tip}失败!")
      end
      appname2 = @tc_args[2][:name]
      tip      = "应用名由'#{appname2}'======>修改为'#{@tc_app_name2}'"
      puts tip.to_gbk
      rs_app= @iam_obj.mod_app(appname2, @token, @admin_id, @tc_args2)
      puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_appformat_msg, rs_app["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_appformat_code, rs_app["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_appformat_desc, rs_app["err_desc"], "#{tip}返回错误desc不正确!")
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
