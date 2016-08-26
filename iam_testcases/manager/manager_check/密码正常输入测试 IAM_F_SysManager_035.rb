#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_035", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_man_name1 = "SysManager_035@zhilutec.com"
        @tc_passwd1   = "123456"
        @tc_man_name2 = "SysManager_0351@zhilutec.com"
        @tc_passwd2   = "abcdefghijklmnopqrstuvwxyz000111"
        @tc_man_name3 = "SysManager_0352@zhilutec.com"
        @tc_passwd3   = "zhilu_22109"
        @tc_man_names =[@tc_man_name1, @tc_man_name2, @tc_man_name3]
        @tc_passwds   =[@tc_passwd1, @tc_passwd2, @tc_passwd3]
        @tc_nickname  = "autotest_whl"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3������һ������Ա�������ʽ��ȷ��") {
            #�������Ա�Ѿ���������ɾ��
            @tc_man_names.each_with_index do |acc, _index|
                @iam_obj.del_manager(acc)
                puts "��������Ա:��#{acc}�������볤��Ϊ#{@tc_passwds[_index].size}".encode("GBK")
                rs = @iam_obj.manager_add(acc, @tc_nickname, @tc_passwds[_index])
                puts "RESULT MSG:#{rs['msg']}".encode("GBK")
                assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Ա��#{acc}��ʧ��!")
                assert_equal(@ts_add_msg, rs["msg"], "��ӳ�������Ա��#{acc}��ʧ��!")
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
