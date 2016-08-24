#
# description:
# author:wuhongliang
# 无法删除中间的空格
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_030", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devnames  = %w(zhilutec_dev1 zhilutec_dev2 zhilutec_dev3)
    @tc_args      = {type: "account", cond: @tc_usr_phone}
    @tc_devmacs   = [" 00:88:A1:BB:CC:DD", "00:88:A1:BB:CC:DD ", "00:88:A 1:BB: CC:DD"]
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("2、用户登录获取用户uid号；") {
      rs = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs["result"], "用户登录失败!")
      @uid = rs["uid"]
    }

    operate("3、用户添加设备mac（mac地址带有空格）；") {
      @tc_devmacs.each_with_index do |devmac, index|
        rs1 = @iam_obj.add_device(@tc_devnames[index], devmac, @uid)
        tip = "用户添加设备mac:'#{devmac}'"
        puts tip.to_gbk
        assert_equal(@ts_add_rs, rs1["result"], "#{tip}失败!")
        devinfo = @iam_obj.get_spec_dev_info(@tc_devnames[index], @uid)
        assert_equal(devmac.upcase.delete(" "), devinfo["device_mac"], "#{tip}失败!")
        @iam_obj.qd_dev(@tc_devnames[index], @uid)
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
