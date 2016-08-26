#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_047", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname   = "Mydevice"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
    @tc_devmac1   = "00:88:00:00:00:01"
    @tc_app_name  = "zhilutecApp"
    @tc_args      = {name: @tc_app_name, provider: "autotest", redirect_uri: @ts_app_redirect_uri, comments: "autotest"}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args) #用户注册
      rs        = @iam_obj.manager_login #管理员登录
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("2、获取登录用户uid号；") {
      @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args) #用户注册
      rs        = @iam_obj.manager_login #管理员登录
      @admin_id = rs["uid"]
      @token    = rs["token"]
    }

    operate("3、获取录入设备A的device_id号；") {
      puts "创建应用名为'#{@tc_app_name}'".to_gbk
      rs_app=@iam_obj.qc_app(@tc_app_name, @token, @admin_id, @tc_args, "1") #创建应用并激活
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")
      tip = "获取应用ID"
      puts tip.to_gbk
      rs_client_id = @iam_obj.get_client_id(@tc_app_name, @token, @admin_id)

      #用户登录
      rs_login     = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs_login["result"], "用户登录失败!")
      @uid = rs_login["uid"]
      #添加设备
      op1  = "添加设备"
      puts op1.to_gbk
      rs_add = @iam_obj.add_device(@tc_devname, @tc_devmac1, @uid)
      assert_equal(@ts_add_rs, rs_add["result"], "#{op1}失败!")

      #设备绑定应用
      appid_arr = [rs_client_id]
      rs_bind   = @iam_obj.qb_dev(@tc_devname, @uid, appid_arr)
      assert_equal(@ts_admin_log_rs, rs_bind["result"], "设备绑定应用失败!")
    }

    operate("4、删除设备A；") {
      rs=@iam_obj.qd_dev(@tc_devname, @uid)
      assert_equal(@ts_add_rs, rs["result"], "删除绑定应用的设备失败!")
      assert_equal(@ts_delete_msg, rs["msg"], "删除绑定应用的设备失败!")
    }

    operate("5、用户重新添加设备A；") {
      rs_add = @iam_obj.add_device(@tc_devname, @tc_devmac1, @uid)
      assert_equal(@ts_add_rs, rs_add["result"], "用户重新添加设备A失败!")

      rs_app = @iam_obj.dev_binding_apps(@tc_devname, @uid)
      assert_empty(rs_app["relapps"], "重新添加设备原绑定关系未解除")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_device(@tc_devname, @tc_usr_phone, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_name)
    }
  end

}
