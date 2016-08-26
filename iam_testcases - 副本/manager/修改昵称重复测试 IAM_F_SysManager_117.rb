#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_117", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name1 = "jiandan@zhilutec.com"
    @tc_man_name2 = "shuizhu@zhilutec.com"
    @tc_nickname1 = "�嵰��"
    @tc_nickname2 = "�嵰��"
    @tc_passwd    = "zhilutec"
    @tc_args1     = {"nickname" => @tc_nickname2, "comments" => "jiandan"}

  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡϵͳ����Աid�ź�tokenֵ��") {
      #�������Ա�Ѿ���������ɾ��
      @iam_obj.del_manager(@tc_man_name1)
      puts "��������Ա:��#{@tc_man_name1}��".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "���ϵͳ����Ա#{@tc_man_name1}ʧ��!")
      assert_equal(@ts_add_msg, rs["msg"], "���ϵͳ����Ա#{@tc_man_name1}ʧ��!")

      @iam_obj.del_manager(@tc_man_name2)
      puts "��������Ա:��#{@tc_man_name2}��".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name2, @tc_nickname2, @tc_passwd)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "���ϵͳ����Ա#{@tc_man_name2}ʧ��!")
      assert_equal(@ts_add_msg, rs["msg"], "���ϵͳ����Ա#{@tc_man_name2}ʧ��!")
    }

    operate("3���޸�nickname��ϢΪ�Ѵ��ڵ��ǳƣ�") {
      puts "�޸Ĺ���Ա#{@tc_man_name2}�ǳ�Ϊ'#{@tc_nickname1}'�����Ա#{@tc_man_name1}���ǳ�һ��".to_gbk
      rs = @iam_obj.edit_mana_info(@tc_args1, @tc_man_name2, @tc_passwd)
      assert_equal(@ts_add_rs, rs["result"], "�޸��ǳ�Ϊ'#{@tc_args1["nickname"]}ʧ��!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name1)
      @iam_obj.del_manager(@tc_man_name2)
    }
  end

}
