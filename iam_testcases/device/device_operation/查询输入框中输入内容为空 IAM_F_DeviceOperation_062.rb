#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_062", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_dev_name  = "autotest_dev"
    @tc_dev_mac   = "00:1E:A2:00:01:51"
    @tc_cond_name = ""
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@ts_phone_usr}注册失败")
    }

    operate("2、获取登录用户uid号；") {
      @rs = @iam_obj.usr_add_devices(@tc_dev_name, @tc_dev_mac, @ts_phone_usr, @ts_usr_pw)
      assert_equal(1, @rs["result"], "用户增加设备失败")
    }

    operate("3、查询字段输入为空时查询；") {
      args = {"type" => "name", "cond" => @tc_cond_name}
      rs   = @iam_obj.usr_get_devlist(@ts_phone_usr, @ts_usr_pw, args)
      refute_equal("0", rs["totalRows"], "查询字段输入为空时，未能查询到设备")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
    }
  end

}
