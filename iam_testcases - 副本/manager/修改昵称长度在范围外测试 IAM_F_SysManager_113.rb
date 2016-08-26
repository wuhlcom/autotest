#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_113", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "dapanji@zhilutec.com"
    @tc_nickname = "�½����̼�"
    @tc_passwd   = "zhilutec"
    @tc_args     = {"nickname" => "235"*10+"gua", "comments" => @tc_nickname}
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

    operate("3���޸�nickname��Ϣ��") {
      puts "�ǳ�#{@tc_args["nickname"]}�ĳ���Ϊ#{@tc_args["nickname"].size}".to_gbk
      rs = @iam_obj.edit_mana_info(@tc_args, @tc_man_name, @tc_passwd)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_nickformat_code, rs["err_code"], "�ǳƳ���Ϊ#{@tc_args["nickname"].size}����code����!")
      assert_equal(@ts_err_nickformat, rs["err_msg"], "�ǳƳ���Ϊ#{@tc_args["nickname"].size}����msg����!")
      assert_equal(@ts_err_nickformat_desc, rs["err_desc"], "�ǳƳ���Ϊ#{@tc_args["nickname"].size}desc!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
