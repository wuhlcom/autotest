#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_038", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_man_name1 = "SysManager_038@zhilutec.com"
        @tc_passwd1   = "�м�1234"
        @tc_man_name2 = "SysManager_0351@zhilutec.com"
        @tc_passwd2   = "We$%*^&2"
        @tc_man_name3 = "SysManager_0352@zhilutec.com"
        @tc_passwd3   = "��������������"
        @tc_man_names =[@tc_man_name1, @tc_man_name2, @tc_man_name3]
        @tc_passwds   =[@tc_passwd1, @tc_passwd2, @tc_passwd3]
        @tc_nickname  = "autotest_whl"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3������һ������Ա�������쳣��ʽ��") {
            #�������Ա�Ѿ���������ɾ��
            @tc_man_names.each_with_index do |acc, _index|
                @iam_obj.del_manager(acc)
                puts "��������Ա:��#{acc}��������Ϊ'#{@tc_passwds[_index]}'".encode("GBK")
                rs = @iam_obj.manager_add(acc, @tc_nickname, @tc_passwds[_index])
                puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
                puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
                puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
                assert_equal(@ts_err_pwformat_code, rs["err_code"], "����Ϊ#{@tc_passwds[_index]}Ӧ��ʾʧ��!")
                assert_equal(@ts_err_pwformat, rs["err_msg"], "����Ϊ#{@tc_passwds[_index]}Ӧ��ʾʧ��!")
                assert_equal(@ts_err_pwformat_desc, rs["err_desc"], "����Ϊ#{@tc_passwds[_index]}Ӧ��ʾʧ��!")
            end
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
