#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_130", "level" => "P1", "auto" => "n"}

  def prepare
    @tc_man_name  = "toubu@zhilutec.com"
    @tc_nickname  = "ͷ��"
    @tc_passwd    = "zhilutec"
    @tc_comments  = "���ι�"
    @tc_comments1 = ("����·֪��¥B��3¥304~!@#$%^&*()_+{}:\"|<>?-=[];'\\,./YZipqf2"*5)
    @tc_args1     = {"nickname" => @tc_nickname, "comments" => @tc_comments1}
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡϵͳ����Աuid��tokenֵ��") {
      #�������Ա�Ѿ���������ɾ��
      @iam_obj.del_manager(@tc_man_name)
      puts "��������Ա:��#{@tc_man_name}��".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd, "2", @tc_comments)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "���ϵͳ����Աʧ��!")
      assert_equal(@ts_add_msg, rs["msg"], "���ϵͳ����Աʧ��!")
    }

    operate("3���޸�comments��ϢΪһ������ַ����ȣ�") {
      puts "�޸�comments����Ϊ#{@tc_args1["comments"].size}".to_gbk
      rs = @iam_obj.edit_mana_info(@tc_args1, @tc_man_name, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "ϵͳ����Ա��ע����Ϊ#{@tc_args1["comments"].size}ʧ��!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
