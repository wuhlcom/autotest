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
    devmac2       = %w(��2:10:18:01:01:01 02:��0:18:01:01:01 02:10:��8:01:01:01 02:10:18:��1:01:01 02:10:18:01:��1:01 02:10:18:01:01:��1)
    devmac3       = %w(~2:10:18:01:01:01 02:!0:18:01:01:01 02:10:@8:01:01:01 02:10:18:#1:01:01 02:10:18:01:$1:01 02:10:18:01:01:%1 02::10:18:01:01:01:02)
    @tc_devmac_arr=devmac1+devmac2+devmac3
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2���û���¼��ȡ�û�uid�ţ�") {
      rs = @iam_obj.phone_usr_reg(@tc_usr_phone, @tc_usr_pw, @tc_args)
    }

    operate("3���û���ӵĸ�ʽ�쳣���豸MAC��") {
      rs = @iam_obj.user_login(@tc_usr_phone, @tc_usr_pw)
      assert_equal(@ts_add_rs, rs["result"], "�û���¼ʧ��!")
      uid = rs["uid"]

      @tc_devmac_arr.each do |devmac|
        rs1 = @iam_obj.add_device(@tc_devname1, devmac, uid)
        tip = "�û�����豸mac'#{devmac}'"
        puts tip.to_gbk
        puts "RESULT err_msg:'#{rs1['err_msg']}'".encode("GBK")
        puts "RESULT err_code:'#{rs1['err_code']}'".encode("GBK")
        puts "RESULT err_desc:'#{rs1['err_desc']}'".encode("GBK")
        puts "==="*15
        assert_equal(@ts_err_devauth_msg, rs1["err_msg"], "#{tip}���ش�����Ϣ����ȷ!")
        assert_equal(@ts_err_devauth_code, rs1["err_code"], "#{tip}���ش���code����ȷ!")
        assert_equal(@ts_err_devauth_desc, rs1["err_desc"], "#{tip}���ش���desc����ȷ!")
      end
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {

    }
  end

}
