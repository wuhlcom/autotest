#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_045", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_appname          = "whlmodify008"
    @tc_provider         = "whl"
    @tc_comments         = "whlmodify"
    @tc_args             = {name: @tc_appname, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_app_comments_max = "中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*"+
        "中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*"+
        "中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*中文24zimu$%^&*中24zi$^*"
    p "comments简介输入框中输入#{@tc_app_comments_max.size}个字符！".encode("GBK")
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      @res = @iam_obj.manager_login #管理员登录->得到uid和token
      assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
    }

    operate("2、获取知路管理员token值；") {
      @admin_id    = @res["uid"]
      @admin_token = @res["token"]
      rs           = @iam_obj.qc_app(@tc_appname, @admin_token, @admin_id, @tc_args)
      assert_equal(@ts_add_rs, rs["result"], "创建应用失败!")
    }

    operate("3、获取修改应用的应用ID号;") {
      @client_id = @iam_obj.get_client_id(@tc_appname, @admin_token, @admin_id)
    }

    operate("4、修改comments为最大长度值；") {
      args = {name: @tc_appname, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments_max}
      @rs  = @iam_obj.modify_apply(@admin_id, @admin_token, @client_id, args)
      assert_equal(1, @rs["result"], "修改comments为最大长度值失败")

      #检查是否修改成功
      rs_detail = @iam_obj.apply_details(@client_id, @admin_id, @admin_token)
      assert_equal(@tc_app_comments_max, rs_detail["comments"], "修改comments简介后查询未修改成功！")
    }
  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_appname)
    }
  end

}
