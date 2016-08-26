#
# description:
# 只支持冒号做分段
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_026", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_usr_phone      = "13700001111"
    @tc_usr_pw         = "123456"
    @tc_devname1       = "zhilutec_dev1"
    @tc_devmac1        = "00:88:00:00:00:01"
    @tc_devmac_format2 = @tc_devmac1.gsub(":", "-")
    @tc_devmac_format3 = @tc_devmac1.sub(":", "-")
    @tc_devmac_format4 = @tc_devmac1.delete(":")
    @tc_args           = {type: "account", cond: @tc_usr_phone}
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、用户登录获取用户uid号；") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("3、用户添加设备mac；（和云端一致，只测试冒号间隔符）") {
      rs = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs["result"], "用户登录失败!")

      uid = rs["uid"]
      tip ="用户添加设备mac为‘#{@tc_devmac1}’"
      puts tip.to_gbk
      rs1 = @iam_obj.add_device(@tc_devname1, @tc_devmac1, uid)
      assert_equal(@ts_add_rs, rs1["result"], "#{tip}失败!")
      @iam_obj.qd_dev(@tc_devname1, uid)

      tip ="用户添加设备mac为‘#{@tc_devmac_format2}’"
      puts tip.to_gbk
      rs2 = @iam_obj.add_device(@tc_devname1, @tc_devmac_format2, uid)
      puts "RESULT err_msg:'#{rs2['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs2['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs2['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_devauth_msg, rs2["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_devauth_code, rs2["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_devauth_desc, rs2["err_desc"], "#{tip}返回错误desc不正确!")

      tip ="用户添加设备mac为‘#{@tc_devmac_format3}’"
      puts tip.to_gbk
      rs3 = @iam_obj.add_device(@tc_devname1, @tc_devmac_format3, uid)
      puts "RESULT err_msg:'#{rs3['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs3['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs3['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_devauth_msg, rs3["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_devauth_code, rs3["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_devauth_desc, rs3["err_desc"], "#{tip}返回错误desc不正确!")

      tip ="用户添加设备mac为‘#{@tc_devmac_format4}’"
      puts tip.to_gbk
      rs4 = @iam_obj.add_device(@tc_devname1, @tc_devmac_format4, uid)
      puts "RESULT err_msg:'#{rs4['err_msg']}'".encode("GBK")
      puts "RESULT err_code:'#{rs4['err_code']}'".encode("GBK")
      puts "RESULT err_desc:'#{rs4['err_desc']}'".encode("GBK")
      assert_equal(@ts_err_devauth_msg, rs4["err_msg"], "#{tip}返回错误消息不正确!")
      assert_equal(@ts_err_devauth_code, rs4["err_code"], "#{tip}返回错误code不正确!")
      assert_equal(@ts_err_devauth_desc, rs4["err_desc"], "#{tip}返回错误desc不正确!")
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_device(@tc_devname1, @tc_usr_phone, @tc_usr_pw)
    }
  end

}
