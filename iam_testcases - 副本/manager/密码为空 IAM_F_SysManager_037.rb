#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_037", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_man_name1 = "SysManager_037@zhilutec.com"
        @tc_passwd1   = ""
        @tc_nickname  = "autotest_whl"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3������һ������Ա������Ϊ�գ�") {
            @iam_obj.del_manager(@tc_man_name1)
            puts "��������Ա:��#{@tc_man_name1}�������볤��Ϊ#{@tc_passwd1}".encode("GBK")
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname, @tc_passwd1)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_pwformat_code, rs["err_code"], "����Ϊ��Ӧ��ʾʧ��!")
            assert_equal(@ts_err_pwformat, rs["err_msg"], "����Ϊ��Ӧ��ʾʧ��!")
            assert_equal(@ts_err_pwformat_desc, rs["err_desc"], "����Ϊ��Ӧ��ʾʧ��!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.del_manager(@tc_man_name1)
        }
    end

}
