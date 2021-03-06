#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_017", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_app_name1   = "大蒸笼"
    @tc_app_prov1   = "蒸天下"
    @tc_app_comment = "包子馒头年糕蛋ABC"*25+"烧饼烧表买"
    @tc_args1       ={"name"         => @tc_app_name1,
                      "provider"     => @tc_app_prov1,
                      "redirect_uri" => @ts_app_redirect_uri,
                      "comments"     => @tc_app_comment}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、获取知路管理员token值；") {
    }

    operate("3、创建应用，comments输入255字符；") {
      tip = "创建的应用名'#{@tc_app_name1}'，应用简介内容大小为#{@tc_app_comment.size}"
      puts "#{tip}".to_gbk
      rs_app = @iam_obj.mana_create_app(@tc_args1)
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      assert_equal(@ts_msg_ok, rs_app["msg"], "新增一个应用失败!")
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      puts "删除应用'#{@tc_args1["name"]}'".to_gbk
      @iam_obj.mana_del_app(@tc_args1["name"])
    }
  end

}
