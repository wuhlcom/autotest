#
# description:
# ��ͷ�ո���Զ�ȥ��,���������뽨�鲻ȥ�ո�Ӧ�ñ���
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_128", "level" => "P4", "auto" => "n"}

  def prepare
    @tc_man_name = "zlautotest3@zhilutec.com"
    @tc_nickname = "֪·����"
    @tc_passwd   = "zhilutec"
    @tc_newpw1   = " 123456"
    @tc_newpw2   = "1234567 "
    @tc_newpw3   = "123 456"
    @tc_newpws   = [@tc_passwd, @tc_newpw1, @tc_newpw2]
  end

  def process

    operate("1��ssh��¼IAM��������") {
      #��ӹ���Ա
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Աʧ��!")
    }

    operate("2����ȡ֪·����Աid��tokenֵ��") {
    }

    operate("3��������������пո�") {
      @tc_newpws.each_with_index do |passwd, index|
        next if index ==0
        oldpasswd= @tc_newpws[index-1]
        tip      = "������'#{oldpasswd}'�޸�Ϊ'#{passwd}'"
        puts tip.to_gbk
        puts "������'#{passwd}'����Ϊ#{passwd.size}".to_gbk
        rs = @iam_obj.mana_modpw(oldpasswd, passwd, @tc_man_name)
        assert_equal(@ts_add_rs, rs["result"], "#{tip}ʧ��!")
        rs = @iam_obj.manager_login(@tc_man_name, passwd)
        assert_equal(@ts_add_rs, rs["result"], "#{tip}��¼ʧ��!")
      end

      tip = "������'#{@tc_newpw2}'�޸�Ϊ'#{@tc_newpw3}'"
      puts tip.to_gbk
      puts "������'#{@tc_newpw3}'����Ϊ#{@tc_newpw3.size}".to_gbk
      rs = @iam_obj.mana_modpw(@tc_newpw2, @tc_newpw3, @tc_man_name)
      # rs = @iam_obj.manager_modpw(passwd, @tc_newpw3, uid, token)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_pwformat_code, rs["err_code"], "#{tip}��ʾcode����!")
      assert_equal(@ts_err_pwformat, rs["err_msg"], "#{tip}��ʾmsg����!")
      assert_equal(@ts_err_pwformat_desc, rs["err_desc"], "#{tip}��ʾdesc����!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
