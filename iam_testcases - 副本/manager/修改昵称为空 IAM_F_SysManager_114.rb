#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_114", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "xiangjiao@zhilutec.com"
    @tc_nickname = "���㽶"
    @tc_passwd   = "zhilutec"
    @tc_args     = {"nickname" => "", "comments" => @tc_nickname}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡϵͳ����Աid�ź�tokenֵ��") {
      #�������Ա�Ѿ���������ɾ��
      @iam_obj.del_manager(@tc_man_name)
      puts "��������Ա:��#{@tc_man_name}��".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "���ϵͳ����Աʧ��!")
      assert_equal(@ts_add_msg, rs["msg"], "���ϵͳ����Աʧ��!")
    }

    operate("3���޸�nickname��ϢΪ�գ�") {
      puts "�ǳ�Ϊ��}".to_gbk
      rs = @iam_obj.edit_mana_info(@tc_args, @tc_man_name, @tc_passwd)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_nickformat_code, rs["err_code"], "�ǳ�Ϊ�շ���code����!")
      assert_equal(@ts_err_nickformat, rs["err_msg"], "�ǳ�Ϊ�շ���msg����!")
      assert_equal(@ts_err_nickformat_desc, rs["err_desc"], "�ǳ�Ϊ�շ���desc����!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
