#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_112", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name = "xinjiang@zhilutec.com"
    @tc_nickname = "�½�����"
    @tc_passwd   = "zhilutec"
    @tc_args1    = {"nickname" => "1", "comments" => "�½����ܹ�"}
    @tc_args2    = {"nickname" => "235"*10+"gu", "comments" => "�½�ɳĮ"}
    @tc_args3    = {"nickname" => "woshi�½�����", "comments" => "�½����ܹ�"}
    @tc_args     = [@tc_args1, @tc_args2, @tc_args3]
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡϵͳ����Աuid��tokenֵ��") {
      #�������Ա�Ѿ���������ɾ��
      @iam_obj.del_manager(@tc_man_name)
      puts "��������Ա:��#{@tc_man_name}��".encode("GBK")
      rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd)
      puts "RESULT MSG:#{rs['msg']}".encode("GBK")
      assert_equal(@ts_add_rs, rs["result"], "���ϵͳ����Աʧ��!")
      assert_equal(@ts_add_msg, rs["msg"], "���ϵͳ����Աʧ��!")
    }

    operate("3���޸�nickname��Ϣ��") {
      @tc_args.each do |args|
        puts "�ǳ�#{args["nickname"]}�ĳ���Ϊ#{args["nickname"].size}".to_gbk
        rs = @iam_obj.edit_mana_info(args, @tc_man_name, @tc_passwd)
        assert_equal(@ts_add_rs, rs["result"], "ϵͳ����Ա�ǳ�Ϊ#{args["nicname"]}ʧ��!")
      end
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @iam_obj.del_manager(@tc_man_name)
    }
  end

}
