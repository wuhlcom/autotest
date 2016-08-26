#
# description:
# author:wuhongliang
# 云端回收站中的设备
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_040", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_usr_phone = "13700001111"
    @tc_usr_pw    = "123456"
    @tc_devname   = "zhilutec"
    @tc_args      = {type: "account", cond: @tc_usr_phone}
    @tc_devmac1   = "00:1E:A2:00:01:41"
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

    operate("3、用户添加设备A(云端已删除)；") {
      tip = "用户添加设备名称:'#{@tc_devname}'"
      rs1 = @iam_obj.add_device(@tc_devname, @tc_devmac1, @uid)
      puts tip.to_gbk
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
