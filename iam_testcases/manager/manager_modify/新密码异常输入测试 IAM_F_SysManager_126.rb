#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_126", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_man_name = "zlautotest2@zhilutec.com"
    @tc_nickname = "֪·����"
    @tc_passwd   = "zhilutec"
    @tc_newpw1   = "�й��й��й�"
    @tc_newpw2   = "������������"
    @tc_newpw3   = "abcd()_+#@%^"
    @tc_newpws   = [@tc_newpw1, @tc_newpw2, @tc_newpw3]
  end

  def process

    operate("1��ssh��¼IAM��������") {
      #��ӹ���Ա
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Աʧ��!")
    }

    operate("2����ȡ֪·����Աid��tokenֵ��") {
    }

    operate("3���޸�������Ϊ�쳣���룻") {
      rs_login = @iam_obj.manager_login(@tc_man_name, @tc_passwd)
      assert_equal(@ts_add_rs, rs_login["result"], "��������Ա��¼ʧ��!")
      uid   = rs_login["uid"]
      token = rs_login["token"]
      @tc_newpws.each_with_index do |passwd, index|
        tip = "������'#{@tc_passwd}'�޸�Ϊ'#{passwd}'"
        puts tip.to_gbk
        puts "������'#{passwd}'����Ϊ#{passwd.size}".to_gbk
        rs = @iam_obj.manager_modpw(@tc_passwd, passwd, uid, token)
        puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
        puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
        puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
        assert_equal(@ts_err_pwformat_code, rs["err_code"], "#{tip}��ʾcode����!")
        assert_equal(@ts_err_pwformat, rs["err_msg"], "#{tip}��ʾmsg����!")
        assert_equal(@ts_err_pwformat_desc, rs["err_desc"], "#{tip}��ʾdesc����!")
      end
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
