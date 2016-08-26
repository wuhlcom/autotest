#
# description:
# MAC地址输入有大小，但显示应该统一为大写
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_029", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devnames  = %w(zhilutec_dev1 zhilutec_dev2 zhilutec_dev3)
    @tc_args      = {type: "account", cond: @tc_usr_phone}
    @tc_devmacs   = %w(00:88:A1:BB:CC:DD 00:88:a2:bb:cc:de 00:88:Aa:Bb:Cc:Dd)
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、用户登录获取用户uid号；") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("3、用户添加设备mac；") {
      rs = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs["result"], "用户登录失败!")
      uid = rs["uid"]

      @tc_devmacs.each_with_index do |devmac, index|
        rs1 = @iam_obj.add_device(@tc_devnames[index], devmac, uid)
        tip = "用户添加设备mac'#{devmac}'"
        puts tip.to_gbk
        assert_equal(@ts_add_rs, rs1["result"], "#{tip}失败!")
        devinfo = @iam_obj.get_spec_dev_info(@tc_devnames[index], uid)
        assert_equal(devmac.upcase, devinfo["device_mac"], "#{tip}失败!")
      end
    }


  end

  def clearup
    operate("1.恢复默认设置") {
      rs  = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      uid = rs["uid"]
      @tc_devnames.each_with_index do |dev_name|
        @iam_obj.qd_dev(dev_name, uid)
      end
    }
  end

}
