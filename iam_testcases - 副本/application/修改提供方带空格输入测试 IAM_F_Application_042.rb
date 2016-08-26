#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_042", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_args      =[]
    @tc_provider  = "zhilutec"
    @tc_comments  = "autotest"
    @tc_app_name1 = "天山雪梨"
    @tc_app_pro   = "天山 雪莲"
    param_part    = {name: @tc_app_name1, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args1     ={name: @tc_app_name1, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args2     ={name: @tc_app_name1, provider: @tc_app_pro, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}

    @tc_args<<@tc_args1
    @tc_new_pros= [" 冥月教", "黑魔门 "]
    @tc_new_pros.each do |appname|
      param_pro = {provider: appname}
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

    operate("4、修改provider输入值带空格；（中间带空格、和左右带空格）") {
      @tc_args.each_with_index do |args, index|
        next if index==0
        provider = @tc_args[index-1][:provider]
        tip      = "应用提供方由'#{provider}'======>修改为'#{args[:provider]}'"
        puts tip.to_gbk
        rs = @iam_obj.mod_app(@tc_app_name1, @token, @admin_id, args)
        assert_equal(@ts_admin_log_rs, rs["result"], "#{tip}失败!")
        assert_equal(@ts_msg_ok, rs["msg"], "#{tip}失败!")
      end
      tc_pro = @tc_args[2][:provider]
      tip    = "应用提供方由'#{tc_pro}'======>修改为'#{@tc_app_pro}'"
      puts tip.to_gbk
      rs_app= @iam_obj.mod_app(@tc_app_name1, @token, @admin_id, @tc_args2)
      puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_apppro_msg, rs_app["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_apppro_code, rs_app["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_apppro_desc, rs_app["err_desc"], "#{tip}返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
