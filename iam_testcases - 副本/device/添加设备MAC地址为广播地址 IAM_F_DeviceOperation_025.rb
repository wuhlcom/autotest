#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_025", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname   = "zhilutec_dev4"
    @tc_devmac    = "FF:FF:FF:FF:FF:FF"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、用户登录获取用户uid号；") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("3、用户添加设备mac（广播地址）；") {
      rs1 = @iam_obj.usr_add_devices(@tc_devname, @tc_devmac, @tc_usr_phone, @tc_usr_pw)
      tip = "用户添加广播地址"
      puts "RESULT err_msg:'#{rs1['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs1['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs1['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_devauth_msg, rs1["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_devauth_code, rs1["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_devauth_desc, rs1["err_desc"], "#{tip}返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {

    }
  end

}
