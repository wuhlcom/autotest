#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_010", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_app_name1 = "AppMa"
    @tc_app_prov1 = "1"
    @tc_args1     ={"name"         => @tc_app_name1,
                    "provider"     => @tc_app_prov1,
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_app_name2 = "AppFly"
    @tc_app_prov2 = "AppTest001"*3+"EE"
    @tc_args2     ={"name"         => @tc_app_name2,
                    "provider"     => @tc_app_prov2,
                    "redirect_uri" => @ts_app_redirect_uri,
                    "comments"     => "autotest"}
    @tc_app_name3 = "知路应用wu"
    @tc_app_prov3 = "小菜zhilu_01"
    @tc_args3     ={"name"         => @tc_app_name3,
                    "provider"     => @tc_app_prov3,
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

    operate("3、创建应用，provider输入正常值；") {
      @tc_args.each do |args|
        puts "创建应用名为'#{args["name"]}',提供名称长度'#{args["provider"].size}'".to_gbk
        rs_app= @iam_obj.create_apply(@admin_id, @token, args)
        assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
        assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")
      end
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @tc_args.each do |args|
        puts "删除应用'#{args["name"]}'".to_gbk
        @iam_obj.mana_del_app(args["name"])
        # @iam_obj.del_apply(args["name"], @token, @admin_id)
      end
    }
  end

}
