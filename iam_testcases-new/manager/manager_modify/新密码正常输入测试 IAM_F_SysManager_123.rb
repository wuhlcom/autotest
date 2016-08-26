#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_123", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_man_name = "zltest@zhilutec.com"
    @tc_nickname = "֪·����"
    @tc_passwd   = "zhilutec"
    @tc_newpw1   = "123456"
    @tc_newpw2   = "012345678a"*3+"bb"
    @tc_newpw3   = "Zhilutec_123"
    @tc_newpws   = [@tc_passwd, @tc_newpw1, @tc_newpw2, @tc_newpw3]
  end

  def process

    operate("1��ssh��¼IAM��������") {
      #��ӹ���Ա
      rs = @iam_obj.manager_del_add(@tc_man_name, @tc_passwd, @tc_nickname)
      assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Աʧ��!")
    }

    operate("2����ȡ֪·����Աid��tokenֵ��") {
    }

    operate("3���޸������룬����ֵ������") {
      @tc_newpws.each_with_index do |passwd, index|
        next if index ==0
        oldpasswd = @tc_newpws[index-1]
        tip       = "������'#{oldpasswd}'�޸�Ϊ'#{passwd}'"
        puts tip.to_gbk
        puts "������'#{passwd}'����Ϊ#{passwd.size}".to_gbk
        rs = @iam_obj.mana_modpw(oldpasswd, passwd, @tc_man_name)
        assert_equal(@ts_add_rs, rs["result"], "#{tip}ʧ��!")
        rs = @iam_obj.manager_login(@tc_man_name, passwd)
        assert_equal(@ts_add_rs, rs["result"], "#{tip}��¼ʧ��!")
      end
    }

  end

  def clearup

    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end


}
