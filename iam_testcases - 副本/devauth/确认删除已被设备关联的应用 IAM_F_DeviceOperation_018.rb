#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_018", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_app_name  = "IAM_F_DeviceOperation_018"
    @tc_file_mode = "2" #探针
    @tc_comm      = "IAMAPI_TEST自动化测试专用"
    @tc_app_args  ={name: @tc_app_name, provider: @tc_comm, redirect_uri: @ts_app_redirect_uri, comments: @tc_comm}

    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname   = "Dev1"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
    @tc_devmac    = "00:88:A1:BB:CC:DD"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      rs           = @iam_obj.manager_login #管理员登录->得到uid和token
      @admin_uid   =rs["uid"]
      @admin_token =rs["token"]
      puts "创建应用名为'#{@tc_app_name}'".to_gbk
      rs_app=@iam_obj.qc_app(@tc_app_name, @admin_token, @admin_uid, @tc_app_args, "1") #创建应用并激活
      assert_equal(@ts_admin_log_rs, rs_app["result"], "新增一个应用失败!")

      file = "上传应用进程文件'#{@ts_file_so1}'"
      puts file.to_gbk
      loginobj = IamPageObject::FucList.new(@browser)
      loginobj.login(@ts_admin_usr, @ts_admin_pw, @ts_admin_login, @ts_admin_code)
      loginobj.set_app_file(@tc_app_name, @ts_file_so1)

      tip = "管理员获取应用ID"
      puts tip.to_gbk
      rs_client_id = @iam_obj.mana_get_client_id(@tc_app_name)

      #用户注册
      @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)

      puts "用户登录".to_gbk
      rs_login = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs_login["result"], "用户登录失败!")
      @uid = rs_login["uid"]

      op1  = "用户添加设备"
      puts op1.to_gbk
      rs_add = @iam_obj.add_device(@tc_devname, @tc_devmac, @uid)
      assert_equal(@ts_add_rs, rs_add["result"], "#{op1}失败!")

      puts "设备绑定应用".to_gbk
      appid_arr = [rs_client_id]
      rs_bind   = @iam_obj.qb_dev(@tc_devname, @uid, appid_arr)
      assert_equal(@ts_admin_log_rs, rs_bind["result"], "设备绑定应用失败!")
    }

    operate("2、获取应用列表中应用id号；；") {
      rs = @iam_obj.mana_get_app_files(@tc_app_name) #此处必须用此接口以重新获取admin-id和admin-token
      refute_empty(rs, "查询应用业务进程文件为空!")
      file_name   = rs[0]["file_name"]
      file_module = rs[0]["file_module"]
      assert_equal(@ts_so1, file_name, "查询应用业务进程文件失败!")
      assert_equal(@tc_file_mode, file_module, "查询应用业务进程文件失败!")
    }

    operate("3、删除已绑定设备应用业务进程文件；") {
      rs_del=@iam_obj.mana_del_app_file(@tc_app_name, @ts_so1)
      assert_equal(@ts_add_rs, rs_del["result"], "删除应用业务进程文件失败!")
      assert_equal(@ts_msg_ok, rs_del["msg"], "删除应用业务进程文件失败!")

      rs = @iam_obj.mana_get_app_files(@tc_app_name) #此处必须用此接口以重新获取admin-id和admin-token
      assert_empty(rs, "应用业务进程文件未删除!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_device(@tc_devname, @tc_usr_phone, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_name)
    }
  end

}
