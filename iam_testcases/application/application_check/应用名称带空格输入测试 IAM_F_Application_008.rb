#
# description:
# 两头有空格会自动去除
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_008", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_app_name1 = " AppOne"
    @tc_args1     ={"name"         => @tc_app_name1,
                    "provider"     => "autotest",
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_app_name2 = "AppTwo "
    @tc_args2     ={"name"         => @tc_app_name2,
                    "provider"     => "autotest",
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_app_name3 = "App Three"
    @tc_args3     ={"name"         => @tc_app_name3,
                    "provider"     => "autotest",
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

    operate("3、创建应用，其中名称带空格输入；") {
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
        puts "删除应用'#{args["name"]}'".to_gbk
        @iam_obj.del_apply(args["name"], @token, @admin_id)
      end
    }
  end

}
