#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_071", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_phone_usr    = "13700044444"
    @tc_usr_pw       = "123456"
    @tc_usr_regargs  = {type: "account", cond: @tc_phone_usr}

    @tc_app_name1    = "application1"
    @tc_app_name2    = "application12"
    @tc_app_name3    = "app3"
    @tc_app_name4    = "lication4"
    @tc_app_name5    = "lication6"
    @tc_app_provider = "wuhlcom"
    @tc_app_comments = "wuhongliang"
    @tc_dev_name     = "autotest_dev"
    @tc_dev_mac      = "00:1E:A2:00:01:51"

    @tc_app_names    =[@tc_app_name1, @tc_app_name2, @tc_app_name3, @tc_app_name4, @tc_app_name5]
    @tc_app_part     ={provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}
    @tc_app_infos    = []
    @tc_app_names.each do |appname|
      args1 = {name: appname}
      args  = args1.merge(@tc_app_part)
      @tc_app_infos<<args
    end

  end

  def process

    operate("1、ssh登录到IAM服务器；") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")

      rs2    = @iam_obj.manager_login()
      @uid   = rs2["uid"]
      @token = rs2["token"]

      @tc_app_infos.each do |app|
        tip ="创建应用'#{app[:name]}'"
        rs3 = @iam_obj.qc_app(app[:name], @token, @uid, app, "1")
        assert_equal(1, rs3["result"], "#{tip}失败")
      end
    }

    operate("2、查询可以授权的应用列表；") {
      rs = @iam_obj.usr_add_devices(@tc_dev_name, @tc_dev_mac, @tc_phone_usr, @tc_usr_pw)
      assert_equal(1, rs["result"], "用户增加设备失败")
    }

    operate("3、对设备授权5个应用；") {
      tip           = "对设备授权5个应用"
      @clientid_arr = []
      @tc_app_names.each do |appname|
        client_id = @iam_obj.get_client_id(appname, @token, @uid)
        @clientid_arr << client_id
      end
      rs = @iam_obj.usr_dev_bindapp(@tc_dev_name, @clientid_arr, @tc_phone_usr, @tc_usr_pw)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_mulapp_code, rs["err_code"], "#{tip}返回code错误!")
      assert_equal(@ts_err_mulapp_msg, rs["err_msg"], "#{tip}返回msg错误")
      assert_equal(@ts_err_mulapp_desc, rs["err_desc"], "#{tip}返回desc错误!")
    }

    operate("4、对设备授权4个应用；") {
      cp_clientid = @clientid_arr.dup
      four_app    = cp_clientid.delete_at(0)
      rs          = @iam_obj.usr_dev_bindapp(@tc_dev_name, cp_clientid, @tc_phone_usr, @tc_usr_pw)
      assert_equal(1, rs["result"], "对设备授权4个应用时失败")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_names)
    }
  end

}
