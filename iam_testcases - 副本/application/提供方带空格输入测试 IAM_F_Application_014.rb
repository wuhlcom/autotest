#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_014", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_app_name1 = "人脑控制"
    @tc_app_pro1  = " AppOne"
    @tc_args1     ={"name"         => @tc_app_name1,
                    "provider"     => @tc_app_pro1,
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_app_name2 = "自动开发"
    @tc_app_pro2  = "AppTwo "
    @tc_args2     ={"name"         => @tc_app_name2,
                    "provider"     => @tc_app_pro2,
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_app_name3 = "狙击开关"
    @tc_app_pro3  = "App Three"
    @tc_args3     ={"name"         => @tc_app_name3,
                    "provider"     => @tc_app_pro3,
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_args      =[@tc_args1, @tc_args2]
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理员token值；") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("3、创建应用，provider输入带有空格（若是左右存在空格，则保存成功）；") {
      @tc_args.each do |args|
        tip = "创建应用名为'#{args["name"]}"
        puts "#{tip}".to_gbk
        rs_app= @iam_obj.create_apply(@admin_id, @token, args)
        assert_equal(@ts_admin_log_rs, rs_app["result"], "#{tip}失败!")
        assert_equal(@ts_msg_ok, rs_app["msg"], "#{tip}失败!")
      end
      tip   = "创建应用名为'#{@tc_args3["name"]}"
     rs_app= @iam_obj.create_apply(@admin_id, @token, @tc_args3)
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
      @tc_args.each do |args|
        puts "删除应用'#{args["name"]}'".to_gbk
        @iam_obj.mana_del_app(args["name"])
      end
    }
  end

}
