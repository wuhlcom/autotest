#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_065", "level" => "P2", "auto" => "n"}

  def prepare
    @tc_phone_usr   = "13700024444"
    @tc_usr_pw      = "123456"
    @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}

    @tc_dev_name = "autotest_dev"
    @tc_dev_mac  = "00:1E:A2:00:01:51"
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

    operate("3、按设备名称查询，查询字段前后带有空格；") {
      p "查询字段前带有空格".encode("GBK")
      name = " " + @tc_dev_name
      args = {"type" => "name", "cond" => name}
      rs   = @iam_obj.usr_get_devlist(@tc_phone_usr, @tc_usr_pw, args)
      assert_equal(@tc_dev_name, rs["resList"][0]["device_name"], "查询字段前带有空格，按设备名查询未能查询到该设备")

      p "查询字段后带有空格".encode("GBK")
      name = @tc_dev_name + " "
      args = {"type" => "name", "cond" => name}
      rs1  = @iam_obj.usr_get_devlist(@tc_phone_usr, @tc_usr_pw, args)
      assert_equal(@tc_dev_name, rs1["resList"][0]["device_name"], "查询字段后带有空格，按设备名查询未能查询到该设备")
    }

    operate("4、按设备名称查询，查询字段中间带有空格或输入全部空格；") {
      p "查询字段中间带有空格".encode("GBK")
      name = @tc_dev_name.gsub("_", "_ ")
      args = {"type" => "name", "cond" => name}
      rs   = @iam_obj.usr_get_devlist(@tc_phone_usr, @tc_usr_pw, args)
      assert_equal("0", rs["totalRows"], "查询字段中间带有空格，能查询到该设备")

      p "查询输入框中直接输入多个空格".encode("GBK")
      name = "             "
      args = {"type" => "name", "cond" => name}
      rs   = @iam_obj.usr_get_devlist(@tc_phone_usr, @tc_usr_pw, args)
      refute_equal("0", rs["totalRows"], "查询输入框中直接输入多个空格，未查询到设备")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_device(@tc_dev_name, @tc_phone_usr, @tc_usr_pw)
      @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
    }
  end

}
