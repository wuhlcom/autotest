#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_040", "level" => "P4", "auto" => "n"}

  def prepare

    @tc_man_name1 = "SysManager_0401@zhilutec.com"
    @tc_passwd1   = " 123456"
    @tc_man_name2 = "SysManager_0402@zhilutec.com"
    @tc_passwd2   = "123456 "
    @tc_man_name3 = "SysManager_0400@zhilutec.com"
    @tc_passwd3   = "1234 56"
    @tc_man_names =[@tc_man_name1, @tc_man_name2]
    @tc_passwds   =[@tc_passwd1, @tc_passwd2]
    @tc_nickname  = "IAM_F_SysManager_040"
  end

  def process

    operate("1��ssh��¼IAM��������") {
    }

    operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
    }

    operate("3������һ������Ա��������пո�") {
      #�������Ա�Ѿ���������ɾ��
      @tc_man_names.each_with_index do |acc, _index|
        tip = "��������Ա:��#{acc}��������Ϊ'#{@tc_passwds[_index]}'"
        puts tip.encode("GBK")
        rs_add = @iam_obj.manager_del_add(acc, @tc_passwds[_index], @tc_nickname)
        assert_equal(@ts_add_rs, rs_add["result"], "#{tip}ʧ��!")
      end
      tip2 = "��������Ա:��#{@tc_man_name3}��������Ϊ'#{@tc_passwd3}'"
      puts tip2.encode("GBK")
      rs = @iam_obj.manager_del_add(@tc_man_name3, @tc_passwd3, @tc_nickname)
      puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
      puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
      puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
      assert_equal(@ts_err_pwformat_code, rs["err_code"], "#{tip2}����code����!")
      assert_equal(@ts_err_pwformat, rs["err_msg"], "#{tip2}����msg����")
      assert_equal(@ts_err_pwformat_desc, rs["err_desc"], "#{tip2}����desc����!")
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {
      @tc_man_names.each do |acc|
        puts "delete manager:#{acc}"
        @iam_obj.del_manager(acc)
      end
    }
  end

}
