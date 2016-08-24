#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_028", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname1  = "zhilutec_dev1"
    @tc_args      = {type: "account", cond: @tc_usr_phone}

    devmac1       = %w(G2:10:18:01:01:01 02:G0:18:01:01:01 02:10:G8:01:01:01 02:10:18:G1:01:01 02:10:18:01:G1:01 02:10:18:01:01:G1)
    devmac2       = %w(中2:10:18:01:01:01 02:中0:18:01:01:01 02:10:中8:01:01:01 02:10:18:中1:01:01 02:10:18:01:中1:01 02:10:18:01:01:中1)
    devmac3       = %w(~2:10:18:01:01:01 02:!0:18:01:01:01 02:10:@8:01:01:01 02:10:18:#1:01:01 02:10:18:01:$1:01 02:10:18:01:01:%1 02::10:18:01:01:01:02)
    @tc_devmac_arr=devmac1+devmac2+devmac3
  end

  def process

    operate("1、ssh登录IAM服务器；") {
    }

    operate("2、用户登录获取用户uid号；") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("3、用户添加的格式异常的设备MAC；") {
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
