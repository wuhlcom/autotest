#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_043", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname   = "yinyin"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
    @tc_devmac1   = "00:88:00:00:00:01"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("2、获取登录用户的uid号；") {
      rs = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs["result"], "用户登录失败!")
      @uid = rs["uid"]
    }

    operate("3、获取录入设备device_id号；") {
      rs= @iam_obj.add_device(@tc_devname, @tc_devmac1, @uid)
      assert_equal(@ts_add_rs, rs["result"], "添加设备失败!")
    }

    operate("4、删除设备；") {
      rs=@iam_obj.qd_dev(@tc_devname, @uid)
      assert_equal(@ts_add_rs, rs["result"], "删除设备失败!")
      assert_equal(@ts_delete_msg, rs["msg"], "删除设备失败!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
       @iam_obj.usr_delete_device(@tc_devname, @tc_usr_phone, @tc_usr_pw)
    }
  end

}
