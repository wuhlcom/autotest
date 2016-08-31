#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_072", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_phone_usr    = "13744044444"
    @tc_usr_pw       = "123456"
    @tc_usr_regargs  = {type: "account", cond: @tc_phone_usr}
    @tc_app_name1    = "lication6"
    @tc_app_provider = "zhilutest"
    @tc_app_comments = "whl"
    @tc_dev_name     = "autotest_dev"
    @tc_dev_mac      = "00:1E:A2:00:01:51"
    @tc_app_args     = {name: @tc_app_name1, provider: @tc_app_provider, redirect_uri: @ts_app_redirect_uri, comments: @tc_app_comments}
    @tc_err_code     = "40002"
  end

  def process

    operate("1、ssh登录到IAM服务器；") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")

      @rs1 = @iam_obj.qca_app(@tc_app_name1, @tc_app_args, "1")
      assert_equal(1, @rs1["result"], "创建应用1失败")

      @rs = @iam_obj.usr_add_devices(@tc_dev_name, @tc_dev_mac, @tc_phone_usr, @tc_usr_pw)
      assert_equal(1, @rs["result"], "用户增加设备失败")
    }

    operate("2、查询可以授权的应用列表；") {
      client_id = @iam_obj.mana_get_client_id(@tc_app_name1)
      args      = {"client_id" => client_id, "name" => @tc_app_name1}
      rs        = @iam_obj.device_app_list
      assert(rs.include?(args), "无法查询到应用列表")
    }

    operate("3、设备授权应用为空；") {
      tip        = "设备授权应用为空"
      client_arr = []
      rs         = @iam_obj.dev_binding_apply("", client_arr)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal( @ts_err_appid_code, rs["err_code"], "#{tip}返回code错误!")
      assert_equal( @ts_err_appid_msg, rs["err_msg"], "#{tip}返回msg错误")
      assert_equal( @ts_err_appid_desc, rs["err_desc"], "#{tip}返回desc错误!")
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
      @iam_obj.mana_del_app(@tc_app_name1)
    }
  end

}
