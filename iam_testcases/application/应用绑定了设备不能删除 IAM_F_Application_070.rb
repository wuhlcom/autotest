#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_Application_070", "level" => "P1", "auto" => "n"}

  def prepare
    # @tc_app_usr      = "autotest_new"
    # @tc_app_provider = "autotest"
    # @tc_app_red_uri  = "http://192.168.10.9"
    @tc_dev_name = "autotest_dev"
    @tc_dev_mac  = "00:1A:31:00:01:78"
    @tc_err_code = "22015"

    @tc_superapp_usr = "autotest_super"
    @tc_app_provider = "autotest"
    @tc_app_red_uri  = "http://192.168.10.9"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      # @res = @iam_obj.manager_login #管理员登录->得到uid和token
      # assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
      # @admin_id    = @res["uid"]
      # @admin_token = @res["token"]
    }

    operate("2、获取知路管理员token值；") {
      p "创建一个超级管理员账户".encode("GBK")
      rs = @iam_obj.manager_del_add(@ts_app_super_manage, @ts_app_manage_pwd, @ts_app_super_manage_nickname)
      assert_equal(1, rs["result"], "创建超级管理员失败！")
      p "创建一个新应用".encode("GBK")
      args = {name: @tc_superapp_usr, provider: @tc_app_provider, redirect_uri: @tc_app_red_uri, comments: "whl"}
      rs   = @iam_obj.qca_app(args["name"], args, "1", @ts_app_super_manage, @ts_app_manage_pwd)
      assert_equal(1, rs["result"], "超级管理员创建应用失败！")

      p @client_id = @iam_obj.mana_get_client_id(@tc_superapp_usr, nil, @ts_app_super_manage, @ts_app_manage_pwd)

    }

    operate("3、获取要删除应用ID号，其中该应用已绑定授权设备；") {
      # 应用绑定设备
      p "用户登录返回用户Id和Token".encode("GBK")
      rs      = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
      @usr_id = rs["uid"]
      p "用户添加设备".encode("GBK")
      rs_dev = @iam_obj.add_device(@tc_dev_name, @tc_dev_mac, @usr_id)
      assert_equal(1, rs_dev["result"], "用户添加设备失败")

      p "获取设备ID".encode("GBK")
      @dev_id = @iam_obj.get_dev_id_for_name(@tc_dev_name, @usr_id)

      p "应用绑定设备".encode("GBK")
      rs = @iam_obj.dev_binding_apply(@dev_id, [@client_id])
      assert_equal(1, rs["result"], "应用绑定设备失败！")
    }

    operate("4、删除改应用；") {
      p rs_del = @iam_obj.mana_del_app(@tc_superapp_usr, nil, @ts_app_super_manage, @ts_app_manage_pwd)
      assert_equal(@tc_err_code, rs_del["err_code"], "删除应用失败后返回的错误码不正确！")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.delete_device(@usr_id, @dev_id)
      @iam_obj.mana_del_app(@tc_superapp_usr)
      @iam_obj.del_manager(@ts_app_super_manage)
    }
  end

}
