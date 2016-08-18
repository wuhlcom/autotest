#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_116", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "hongshao@zhilutec.com"
    @tc_nickname = "������"
    @tc_passwd   = "zhilutec"
    @tc_args1    = {"nickname" => " ������", "comments" => @tc_nickname}
    @tc_args2    = {"nickname" => "���� ��", "comments" => @tc_nickname}
    @tc_args3    = {"nickname" => "������ ", "comments" => @tc_nickname}
    @tc_args     = [@tc_args1, @tc_args3]
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

    operate("3���޸�nickname��Ϣ���пո�") {
      @tc_args.each do |args|
        puts "�ǳ�Ϊ'#{args["nickname"]}'".to_gbk
        rs = @iam_obj.edit_mana_info(args, @tc_man_name, @tc_passwd)
        assert_equal(@ts_add_rs, rs["result"], "�޸��ǳ�Ϊ'#{args["nickname"]}ʧ��!")
      end

      puts "�ǳ�Ϊ'#{@tc_args2["nickname"]}'".to_gbk
      rs = @iam_obj.edit_mana_info(@tc_args2, @tc_man_name, @tc_passwd)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_nickformat_code, rs["err_code"], "�ǳ�Ϊ'#{@tc_args2["nickname"]}'����code����!")
      assert_equal(@ts_err_nickformat, rs["err_msg"], "�ǳ�Ϊ'#{@tc_args2["nickname"]}'����msg����!")
      assert_equal(@ts_err_nickformat_desc, rs["err_desc"], "�ǳ�Ϊ'#{@tc_args2["nickname"]}'����desc����!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
