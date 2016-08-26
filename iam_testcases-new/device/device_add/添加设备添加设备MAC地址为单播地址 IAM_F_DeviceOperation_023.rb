#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_023", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname   = "zhilutec_dev1"
    @tc_devmac    = "00:88:00:00:00:01"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、用户登录获取用户uid号；") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("3、用户添加设备mac（单播地址）；") {
      rs = @iam_obj.usr_add_devices(@tc_devname, @tc_devmac, @tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs["result"], "添加用户设备为单播失败!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_device(@tc_devname, @tc_usr_phone, @tc_usr_pw)
    }
  end

}
