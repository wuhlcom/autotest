#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_008", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_man_name = "autotest_whl@zhilutec.com"
        @tc_nickname = "autotest_whl"
        @tc_passwd   = "123456"
    end

    def process

        operate("1��ssh��¼��IAM��������") {
        }

        operate("2����ȡ֪·����Աtokenֵ��") {
            #�������Ա�Ѿ���������ɾ��
            @iam_obj.del_manager(@tc_man_name)
        }

        operate("3��������������Ա��") {
            rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd)
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Աʧ��!")
            assert_equal(@ts_add_msg, rs["msg"], "��ӳ�������Աʧ��!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.del_manager(@tc_man_name)
        }
    end

}
