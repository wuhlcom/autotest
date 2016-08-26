#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_028", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_man_name1 = "13760281503"
        @tc_nickname1 = ""
        @tc_passwd    = "123456"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3������һ������Ա��nicknameΪ�գ�") {
            @iam_obj.del_manager(@tc_man_name1)
            puts "��ӳ�������Ա�˻�Ϊ:#{@tc_man_name1}".to_gbk
            puts "�ǳ�Ϊ��".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_nickformat_code, rs["err_code"], "����ǳ�Ϊ�ճɹ�!")
            assert_equal(@ts_err_nickformat, rs["err_msg"], "����ǳ�Ϊ�ճɹ�!")
            assert_equal(@ts_err_nickformat_desc, rs["err_desc"], "����ǳ�Ϊ�ճɹ�!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.del_manager(@tc_man_name1)
        }
    end

}
