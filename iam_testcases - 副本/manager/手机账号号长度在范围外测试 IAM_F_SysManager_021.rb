#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_021", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_man_name1 = "137602815771"
        @tc_nickname1     = "137602815771"
        @tc_passwd        = "123456"
        @tc_man_name2 = "1376028157"
        @tc_nickname2     = "1376028157"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3���ֻ����������11λ���룬�硰138265454444������������Ա��") {
            #�������Ա�Ѿ���������ɾ��
            @iam_obj.del_manager(@tc_man_name1)
            puts "��ӳ�������Ա�˻�Ϊ:#{@tc_man_name1},�ֻ����볤��Ϊ#{@tc_man_name1.size}".to_gbk
           p rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            # {"err_code":"5003","err_msg":"\u5e10\u53f7\u683c\u5f0f\u9519\u8bef","err_desc":"E_ACCOUNT_FORMAT_ERROR"}
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_accformat_code, rs["err_code"], "����ֻ��˻���������Ա#{@tc_man_name1}Ӧ��ʾʧ��!")
            assert_equal(@ts_err_accformat, rs["err_msg"], "����ֻ��˻���������Ա#{@tc_man_name1}Ӧ��ʾʧ��!")
            assert_equal(@ts_err_accformat_desc, rs["err_desc"], "����ֻ��˻���������Ա#{@tc_man_name1}Ӧ��ʾʧ��!")
        }

        operate("4���ֻ�������С��11λ���룬�硰1382645656������������Ա��") {
            #�������Ա�Ѿ���������ɾ��
            @iam_obj.del_manager(@tc_man_name2)
            puts "��ӳ�������Ա�˻�Ϊ:#{@tc_man_name2},�ֻ����볤��Ϊ#{@tc_man_name1.size}".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name2, @tc_nickname2, @tc_passwd)
            # {"err_code":"5003","err_msg":"\u5e10\u53f7\u683c\u5f0f\u9519\u8bef","err_desc":"E_ACCOUNT_FORMAT_ERROR"}
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_accformat_code, rs["err_code"], "����ֻ��˻���������Ա#{@tc_man_name1}Ӧ��ʾʧ��!")
            assert_equal(@ts_err_accformat, rs["err_msg"], "����ֻ��˻���������Ա#{@tc_man_name1}Ӧ��ʾʧ��!")
            assert_equal(@ts_err_accformat_desc, rs["err_desc"], "����ֻ��˻���������Ա#{@tc_man_name1}Ӧ��ʾʧ��!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
