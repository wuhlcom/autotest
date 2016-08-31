#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
  attr = {"id" => "IAM_F_DeviceOperation_048", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_dev_name2 = "autotest_dev2"
    @tc_dev_mac2  = "00:1a:31:00:01:78"
    @name_editor2 = "0"
  end

  def process

    operate("1、ssh登录IAM服务器；") {
      rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
      assert_equal(@ts_add_rs, rs["result"], "用户#{@ts_phone_usr}注册失败")
    }

    operate("2、获取登录用户uid号；") {
      @rs2 = @iam_obj.usr_add_devices(@tc_dev_name2, @tc_dev_mac2, @ts_phone_usr, @ts_usr_pw)
      assert_equal(1, @rs2["result"], "用户2增加设备失败")
    }

    operate("3、获取录入设备A的device_id号；") {
    }

    operate("4、编辑设备A名称单个字符；") {
      @rss2 = @iam_obj.usr_device_editor(@ts_phone_usr, @ts_usr_pw, @tc_dev_name2, @name_editor2)
      assert_equal(1, @rss2["result"], "修改设备名称失败")
    }

  end

  def clearup
    operate("1.恢复默认设置") {
      @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
    }
  end

}
