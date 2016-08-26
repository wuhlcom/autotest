#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_037", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname   = "zhilutec"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
    @tc_devmac1   = "00:88:00:77:00:01"
    @tc_devmac2   = "00:88:A1:BB:CC:DD"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("2、用户登录获取用户uid号；") {
      rs = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs["result"], "用户登录失败!")
      @uid = rs["uid"]
    }

    operate("3、用户添加设备mac，设备名称为知路科技；") {
      tip = "用户添加设备名称:'#{@tc_devname}'"
      rs1 = @iam_obj.add_device(@tc_devname, @tc_devmac1, @uid)
      puts tip.to_gbk
      assert_equal(@ts_add_rs, rs1["result"], "#{tip}失败!")
    }

    operate("4、再次录入一个设备，设备名称也为知路科技；") {
      tip = "用户再一次添加设备名称:'#{@tc_devname}'"
      rs1 = @iam_obj.add_device(@tc_devname, @tc_devmac2, @uid)
      puts tip.to_gbk
      puts "RESULT err_msg:'#{rs1['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs1['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs1['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_devexists_msg, rs1["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_devexists_code, rs1["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_devexists_desc, rs1["err_desc"], "#{tip}返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_device(@tc_devname, @tc_usr_phone, @tc_usr_pw)
    }
  end

}
