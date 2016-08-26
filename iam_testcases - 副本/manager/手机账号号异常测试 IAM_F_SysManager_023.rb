#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_023", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_man_name1 = "13760281577A"
        @tc_man_name2 = "a13760281577"
        @tc_man_name3 = "13760281577*"
        @tc_man_name4 = "1376028��1577"
        @tc_man_name5 = "13760 281577"
        @tc_man_name6 = "137������������12"
        @tc_man_name7 = "13760cc281577"
        @tc_man_names =[@tc_man_name1, @tc_man_name2, @tc_man_name3, @tc_man_name4, @tc_man_name5, @tc_man_name6, @tc_man_name7]
        @tc_nickname1 = "phone"
        @tc_passwd    = "123456"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3�������쳣�ֻ��ţ������ġ���ĸ�������ַ���ȫ�Ǹ�ʽ��������һ������Ա��") {
            @tc_man_names.each do |acc|
                puts "��ӳ�������Ա�˻�Ϊ:'#{acc}'".to_gbk
                rs = @iam_obj.manager_add(acc, @tc_nickname1, @tc_passwd)
                # {"err_code":"5003","err_msg":"\u5e10\u53f7\u683c\u5f0f\u9519\u8bef","err_desc":"E_ACCOUNT_FORMAT_ERROR"}
                puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
                puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
                puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
                assert_equal(@ts_err_accformat_code, rs["err_code"], "����ֻ��˻�Ϊ#{acc}Ӧ��ʾʧ��!")
                assert_equal(@ts_err_accformat, rs["err_msg"], "����ֻ��˻�Ϊ#{acc}Ӧ��ʾʧ��!")
                assert_equal(@ts_err_accformat_desc, rs["err_desc"], "����ֻ��˻�Ϊ#{acc}Ӧ��ʾʧ��!")
            end
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
