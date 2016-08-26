#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_036", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_man_name1 = "SysManager_035@zhilutec.com"
        @tc_passwd1   = "12345"
        @tc_man_name2 = "SysManager_0351@zhilutec.com"
        @tc_passwd2   = "abcdefghijklmnopqrstuvwxyz0001132"
        @tc_man_names =[@tc_man_name1, @tc_man_name2]
        @tc_passwds   =[@tc_passwd1, @tc_passwd2]
        @tc_nickname  = "autotest_whl"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3������һ������Ա�����벻�ڷ�Χ�ڣ�") {
            #�������Ա�Ѿ���������ɾ��
            @tc_man_names.each_with_index do |acc, _index|
                @iam_obj.del_manager(acc)
                puts "��������Ա:��#{acc}�������볤��Ϊ#{@tc_passwds[_index].size}".encode("GBK")
                rs = @iam_obj.manager_add(acc, @tc_nickname, @tc_passwds[_index])
                puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
                puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
                puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
                assert_equal(@ts_err_pwformat_code, rs["err_code"], "���볤��Ϊ#{@tc_passwds[_index].size}Ӧ��ʾʧ��!")
                assert_equal(@ts_err_pwformat, rs["err_msg"], "���볤��Ϊ#{@tc_passwds[_index].size}Ӧ��ʾʧ��!")
                assert_equal(@ts_err_pwformat_desc, rs["err_desc"], "���볤��Ϊ#{@tc_passwds[_index].size}Ӧ��ʾʧ��!")
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
