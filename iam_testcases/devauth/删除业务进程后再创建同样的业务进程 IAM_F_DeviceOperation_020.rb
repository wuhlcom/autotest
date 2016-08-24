#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_020", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_app_name  = "IAM_F_DeviceOperation_020"
    @tc_file_mode = "2" #探针
    @tc_comm      = "IAMAPI_TEST自动化测试专用"
    @tc_app_args  ={name: @tc_app_name, provider: @tc_comm, redirect_uri: @ts_app_redirect_uri, comments: @tc_comm}
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
      @iam_admin_page = IamPageObject::FucList.new(@browser)
      @iam_admin_page.login(@ts_admin_usr, @ts_admin_pw, @ts_admin_login, @ts_admin_code)
      @iam_admin_page.set_app_file(@tc_app_name, @ts_file_so1)
    }

    operate("2、获取应用A的id号；；") {
      rs = @iam_obj.mana_get_app_files(@tc_app_name) #此处必须用此接口以重新获取admin-id和admin-token
      refute_empty(rs, "查询应用业务进程文件为空!")
      file_name   = rs[0]["file_name"]
      file_module = rs[0]["file_module"]
      assert_equal(@ts_so1, file_name, "查询应用业务进程文件失败!")
      assert_equal(@tc_file_mode, file_module, "查询应用业务进程文件失败!")
    }

    operate("3、删除应用A进程文件B；") {
      rs_del=@iam_obj.mana_del_app_file(@tc_app_name, @ts_so1)
      assert_equal(@ts_add_rs, rs_del["result"], "删除应用业务进程文件失败!")
      assert_equal(@ts_msg_ok, rs_del["msg"], "删除应用业务进程文件失败!")

      rs = @iam_obj.mana_get_app_files(@tc_app_name) #此处必须用此接口以重新获取admin-id和admin-token
      assert_empty(rs, "应用业务进程文件未删除!")
    }

    operate("4、管理员再重新给应用A上传进程文件B；") {
      @iam_admin_page.browser.refresh
      sleep 1
      @iam_admin_page.login(@ts_admin_usr, @ts_admin_pw, @ts_admin_login, @ts_admin_code)
      @iam_admin_page.set_app_file(@tc_app_name, @ts_file_so1)
    }

    operate("5、查询应用A是否存在业务进程文件B；") {
      rs = @iam_obj.mana_get_app_files(@tc_app_name) #此处必须用此接口以重新获取admin-id和admin-token
      refute_empty(rs, "查询应用业务进程文件为空!")
      file_name   = rs[0]["file_name"]
      file_module = rs[0]["file_module"]
      assert_equal(@ts_so1, file_name, "查询重新上传的应用业务进程文件失败!")
      assert_equal(@tc_file_mode, file_module, "查询重新上传的应用业务进程文件失败!")
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_app_name)
    }
  end

}
