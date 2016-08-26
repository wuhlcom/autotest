#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_041", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_args      = []
    @tc_provider  = "zhilutec"
    @tc_comments  = "autotest"
    @tc_app_name1 = "花生仁"
    param_part    = {name: @tc_app_name1, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_args1     = {name: @tc_app_name1, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_new_pros  = ["~#%^*()_+{}:\"|<>?-=[];'\\,./", "１２３４５６"]
    @tc_new_pros.each do |provider|
      param_name = {provider: provider}
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

    operate("3、获取修改应用的ID号;") {
      puts "创建应用名为'#{@tc_app_name1}'".to_gbk
      rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")
    }

    operate("4、修改provider输入异常值；") {
      @tc_args.each do |args|
        provider = args[:provider]
        tip      = "应用提供方由'#{@tc_provider}'======>修改为'#{provider}'"
        puts tip.to_gbk
        rs_app = @iam_obj.mod_app(@tc_app_name1, @token, @admin_id, args)
        puts "RESULT err_msg:'#{rs_app['err_msg']}'".encode("GBK")
        puts "RESULT err_code:'#{rs_app['err_code']}'".encode("GBK")
        puts "RESULT err_desc:'#{rs_app['err_desc']}'".encode("GBK")
        assert_equal( @ts_err_apppro_msg, rs_app["err_msg"], "#{tip}返回错误消息不正确!")
        assert_equal( @ts_err_apppro_code, rs_app["err_code"], "#{tip}返回错误code不正确!")
        assert_equal( @ts_err_apppro_desc, rs_app["err_desc"], "#{tip}返回错误desc不正确!")
      end
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
