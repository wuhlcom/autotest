#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_027", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname1  = "zhilutec_dev1"
    @tc_args      = {type: "account", cond: @tc_usr_phone}

    @tc_devmac1 = "02:10:18:01:01"
    @tc_devmac2 = "02:10:18:01:01:1"
    @tc_devmac3 = "02:10:18:01:01:011"
    @tc_devmac4 = "02:10:18:01:01:01:02"

    @tc_devmac_arr =[@tc_devmac1, @tc_devmac2, @tc_devmac3, @tc_devmac4]

  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、用户登录获取用户uid号；") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("3、用户添加的长度异常设备MAC地址；") {
      rs = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs["result"], "用户登录失败!")
      uid = rs["uid"]

      @tc_devmac_arr.each do |devmac|
        rs1 = @iam_obj.add_device(@tc_devname1, devmac, uid)
        tip = "用户添加设备mac'#{devmac}'"
        puts tip.to_gbk
        puts "RESULT err_msg:'#{rs1['err_msg']}'".encode("GBK")
        puts "RESULT err_code:'#{rs1['err_code']}'".encode("GBK")
        puts "RESULT err_desc:'#{rs1['err_desc']}'".encode("GBK")
        puts "==="*15
        assert_equal(@ts_err_devauth_msg, rs1["err_msg"], "#{tip}返回错误消息不正确!")
        assert_equal(@ts_err_devauth_code, rs1["err_code"], "#{tip}返回错误code不正确!")
        assert_equal(@ts_err_devauth_desc, rs1["err_desc"], "#{tip}返回错误desc不正确!")
      end
    }


  end

  def clearup
    operate("1.恢复默认设置") {

    }
  end

}
