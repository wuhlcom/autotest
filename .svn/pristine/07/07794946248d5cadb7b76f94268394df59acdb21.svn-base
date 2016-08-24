#
# description:
# 手工登录创建应用名:IAM_F_DeviceOperation_013
# 并上传了进程文件
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_013", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_app_name  = "IAM_F_DeviceOperation_013"
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

      file = "上传应用进程文件'#{@ts_file_ko1}'"
      puts file.to_gbk
      loginobj = IamPageObject::FucList.new(@browser)
      loginobj.login(@ts_admin_usr, @ts_admin_pw, @ts_admin_login, @ts_admin_code)
      loginobj.set_app_file(@tc_app_name, @ts_file_ko1)
    }

    operate("2、获取应用列表中应用id号；；") {

    }

    operate("3、查询某个应用的业务进程文件；") {
      rs = @iam_obj.mana_get_app_files(@tc_app_name) #此处必须用此接口以重新获取admin-id和admin-token
      refute_empty(rs, "查询应用业务进程文件为空!")
      file_name   = rs[0]["file_name"]
      file_module = rs[0]["file_module"]
      assert_equal(@ts_ko1, file_name, "查询应用业务进程文件失败!")
      assert_equal(@tc_file_mode, file_module, "查询应用业务进程文件失败!")
    }

  end

  def clearup

    operate("1.恢复默认设置") {
      @iam_obj.mana_del_app(@tc_app_name)
    }

  end

}
