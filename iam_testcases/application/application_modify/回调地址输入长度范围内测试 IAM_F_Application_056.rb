#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_056", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_appname          = "whlmodify008"
    @tc_provider         = "whl"
    @tc_comments         = "whlmodify"
    @tc_args             = {name: @tc_appname, provider: @tc_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_comments}
    @tc_app_redirect_uri = "http://www.jd.com/?cu=true&utm_source=baidu-pinzhuan&utm_medium=cpc&utm_campaign=t_288551095_baidupinzhuan&utm_term=0f3d30c8dba7"
    puts "回调地址长度为：#{@tc_app_redirect_uri.size}!".encode("GBK")
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

    operate("4、修改redirect_uri地址长度在范围内；") {
      tip  ="修改redirect_uri地址为正常格式"
      args = {name: @tc_appname, provider: @tc_provider, redirect_uri: @tc_app_redirect_uri, comments: @tc_comments}
      @rs  = @iam_obj.modify_apply(@admin_id, @admin_token, @client_id, args)
      assert_equal(1, @rs["result"], "modify apply redirect_uri error：#{@rs["err_desc"]}")

      #检查是否修改成功
      rs_detail = @iam_obj.apply_details(@client_id, @admin_id, @admin_token)
      assert_equal(@tc_app_redirect_uri, rs_detail["redirect_uri"], "修改回调地址后查询未修改成功！")
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_appname)
    }
  end

}
