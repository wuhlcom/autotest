#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_051", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_appname          = "whlmodify001"
    @tc_provider         ="whl"
    @tc_comments         ="whlmodify"
    @tc_args             = {name: @tc_appname, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_app_redirect_uri = "www.baidu.com"
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

    operate("4、修改redirect_uri地址不带http://；") {
      tip  = "修改redirect_uri地址不带http://"
      args = {name: @tc_appname, provider: @tc_provider, redirect_uri: @tc_app_redirect_uri, comments: @tc_comments}
      rs = @iam_obj.modify_apply(@admin_id, @admin_token, @client_id, args)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_appurl_code, rs["err_code"], "#{tip}返回code错误!")
      assert_equal(@ts_err_appurl_msg, rs["err_msg"], "#{tip}返回msg错误")
      assert_equal(@ts_err_appurl_desc, rs["err_desc"], "#{tip}返回desc错误!")
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_appname)
    }
  end

}
