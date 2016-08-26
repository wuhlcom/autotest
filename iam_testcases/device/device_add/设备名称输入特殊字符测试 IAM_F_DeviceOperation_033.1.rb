#
# description:
# bug，自动去除了特殊字符，应该是返回错误码，用户名格式不正确
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_033.1", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname   = "知路TEC_&*(_+~!#$%^\\]"
    @tc_devmac    = "00:88:A2:BB:CC:DE"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("2、用户登录获取用户uid号；") {
    }

    operate("3、用户添加设备mac，设备名称有特殊字符；") {
      tip = "设备名称为'#{@tc_devname}'"
      puts tip.to_gbk
      rs = @iam_obj.usr_add_devices(@tc_devname, @tc_devmac, @tc_usr_phone, @tc_usr_pw)
      puts "RESULT err_msg:'#{rs['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_devauth_msg, rs["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_devauth_code, rs["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_devauth_desc, rs["err_desc"], "#{tip}返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
    }
  end

}
