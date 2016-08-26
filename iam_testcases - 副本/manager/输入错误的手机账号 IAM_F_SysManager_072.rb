#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
  attr = {"id" => "IAM_F_SysManager_072", "level" => "P3", "auto" => "n"}

  def prepare
    @tc_man_name1 = "1361234123"
    @tc_man_name2 = "136123412345"
    @tc_man_name3 = "1361234u234"
    @tc_man_names =[@tc_man_name1, @tc_man_name2, @tc_man_name3]
  end

  def process

    operate("1��SSH��¼IAMϵͳ��") {

    }

    operate("2�������ֻ��ţ���ȡ�ֻ���֤�룻") {
      @tc_man_names.each do |phone|
        tip = "�����ֻ���#{phone}��ȡ�ֻ���֤��"
        puts tip.to_gbk
        rs = @iam_obj.request_mobile_code(phone)
        puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
        puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
        puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
        assert_equal(@ts_err_pcode_msg, rs["err_msg"], "#{tip}����msg����!")
        assert_equal(@ts_err_pcode_code, rs["err_code"], "#{tip}����code����!")
        assert_equal(@ts_err_pcode_desc, rs["err_desc"], "#{tip}����desc����!")
      end
    }


  end

  def clearup
    operate("1.�ָ�Ĭ������") {

    }
  end

}
