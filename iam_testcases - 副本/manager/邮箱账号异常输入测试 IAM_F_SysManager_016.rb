#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_016", "level" => "P4", "auto" => "n"}

    def prepare
        str = "�ڣȣɣ̣�".encode("utf-8")
        @tc_man_name1 = "#{str}@zhilutec.com"
        @tc_nickname = "autotest_whl"
        @tc_passwd   = "123456"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3�������˺��쳣����ʱ����������Ա��") {
            #�������Ա�Ѿ���������ɾ��
            # @iam_obj.del_manager(@tc_man_name1)
            puts "��ӳ�������Ա�˻�Ϊ:#{@tc_man_name1}".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname, @tc_passwd)
            # {"err_code":"5003","err_msg":"\u5e10\u53f7\u683c\u5f0f\u9519\u8bef","err_desc":"E_ACCOUNT_FORMAT_ERROR"}
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(rs["err_code"], @ts_err_accformat_code, "��ӳ�������Ա#{@tc_man_name1}ʧ��!")
            assert_equal(rs["err_msg"], @ts_err_accformat, "��ӳ�������Ա#{@tc_man_name1}ʧ��!")
            assert_equal(rs["err_desc"], @ts_err_accformat_desc, "��ӳ�������Ա#{@tc_man_name1}ʧ��!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            # @iam_obj.del_manager(@tc_man_name1)
        }
    end

}
