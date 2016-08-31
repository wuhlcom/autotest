#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_064", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13700014444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}

    @tc_dev_name = "autotest_dev"
    @tc_dev_mac  = "00:1E:A2:00:01:51"
    @name        = "abcdefghijklmnopqrstuvwxyz"*9+"abcdefghijklmnopqrstuv"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")
    }

    operate("2、获取登录用户uid号；") {
      @rs = @iam_obj.usr_add_devices(@tc_dev_name, @tc_dev_mac, @tc_phone_usr, @tc_usr_pw)
      assert_equal(1, @rs["result"], "用户增加设备失败")
    }

    operate("3、按设备名称查询，256个字符；") {
      args = {"type" => "name", "cond" => @name}
      rs   = @iam_obj.usr_get_devlist(@tc_phone_usr, @tc_usr_pw, args)
      assert_equal("0", rs["totalRows"], "按设备名称查询，256个字符，能查询到设备")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_device(@tc_dev_name, @tc_phone_usr, @tc_usr_pw)
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
    }
  end

}
