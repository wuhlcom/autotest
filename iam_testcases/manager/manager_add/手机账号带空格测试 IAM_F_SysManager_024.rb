#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_024", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_man_name1 = " 13760281500"
        @tc_man_name2 = "13760281501 "
        @tc_man_name3 = "1376028 1503"
        @tc_nickname1 = "13760281577"
        @tc_passwd    = "123456"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3���ֻ���ǰ���пո����룬����һ������Ա��") {
            @iam_obj.del_manager(@tc_man_name1.strip)
            puts "��ӳ�������Ա�˻�Ϊ:'#{@tc_man_name1}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Ա'#{@tc_man_name1}'ʧ��!")
            assert_equal(@ts_add_msg, rs["msg"], "��ӳ�������Ա'#{@tc_man_name1}'ʧ��!")

            @iam_obj.del_manager(@tc_man_name2.strip)
            puts "��ӳ�������Ա�˻�Ϊ:'#{@tc_man_name2}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name2, @tc_nickname1, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Ա'#{@tc_man_name2}'ʧ��!")
            assert_equal(@ts_add_msg, rs["msg"], "��ӳ�������Ա'#{@tc_man_name2}'ʧ��!")

            puts "��ӳ�������Ա�˻�Ϊ:'#{@tc_man_name3}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name3, @tc_nickname1, @tc_passwd)
            # {"err_code":"5003","err_msg":"\u5e10\u53f7\u683c\u5f0f\u9519\u8bef","err_desc":"E_ACCOUNT_FORMAT_ERROR"}
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_accformat_code, rs["err_code"], "����ֻ��˻�Ϊ#{@tc_man_name3}Ӧ��ʾʧ��!")
            assert_equal(@ts_err_accformat, rs["err_msg"], "����ֻ��˻�Ϊ#{@tc_man_name3}Ӧ��ʾʧ��!")
            assert_equal(@ts_err_accformat_desc, rs["err_desc"], "����ֻ��˻�Ϊ#{@tc_man_name3}Ӧ��ʾʧ��!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.del_manager(@tc_man_name1.strip)
            @iam_obj.del_manager(@tc_man_name2.strip)
        }
    end

}
