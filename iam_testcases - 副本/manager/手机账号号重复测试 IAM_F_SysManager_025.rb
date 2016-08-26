#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_025", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_man_name1 = "13760281500"
        @tc_nickname1     = "13760281500"
        @tc_passwd        = "123456"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3���ֻ����������룬����һ������Ա��") {
            @iam_obj.del_manager(@tc_man_name1.strip)
            puts "��ӳ�������Ա�˻�Ϊ:#{@tc_man_name1}".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Աʧ��!")
            assert_equal(@ts_add_msg, rs["msg"], "��ӳ�������Աʧ��!")
        }

        operate("4��ʹ�ò���3���ֻ����ٴ���������Ա") {
            puts "�ٴ���ӳ�������Ա�˻�Ϊ:#{@tc_man_name1}".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_acc_exists_code, rs["err_code"], "����ظ��ֻ���#{@tc_man_name1}Ӧ��ʾʧ��!")
            assert_equal(@ts_err_acc_exists, rs["err_msg"], "����ظ��ֻ���#{@tc_man_name1}Ӧ��ʾʧ��!")
            assert_equal(@ts_err_acc_exists_desc, rs["err_desc"], "����ظ��ֻ���#{@tc_man_name1}Ӧ��ʾʧ��!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
