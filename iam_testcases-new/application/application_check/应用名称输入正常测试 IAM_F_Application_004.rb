#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_004", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_app_name1 = "9"
    @tc_args1     ={"name"         => @tc_app_name1,
                    "provider"     => "autotest",
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_app_name2 = "zhiluiamap"*3+"pp"
    @tc_args2     ={"name"         => @tc_app_name2,
                    "provider"     => "autotest",
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_app_name3 = "知路TEST_应用"
    @tc_args3     ={"name"         => @tc_app_name3,
                    "provider"     => "autotest",
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_args      =[@tc_args1, @tc_args2, @tc_args3]
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理员token值；") {
      rs        = @iam_obj.manager_login
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("3、创建应用，其中名称正常输入；") {
      @tc_args.each do |args|
        puts "创建应用名为'#{args["name"]}',长度'#{args["name"].size}'".to_gbk
        rs_app= @iam_obj.create_apply(@admin_id, @token, args)
        assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
        assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")
      end
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
