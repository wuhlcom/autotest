#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_007", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_user_name_1   = " zhilu123@qq.com"
        @tc_user_name_2   = "zhilutest123@qq.com "
        @tc_user_pwd      = "123123"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2��ע������ǰ����пո�") {
            p "����ǰ����пո�".encode("GBK")
            @rs1 = @iam_obj.register_emailusr(@tc_user_name_1, @tc_user_pwd, 1)
            assert_equal(1, @rs1["result"], "ʹ��ǰ����пո������ע��ʱ��ע��ʧ��")

            p "���������пո�".encode("GBK")
            @rs2 = @iam_obj.register_emailusr(@tc_user_name_2, @tc_user_pwd, 1)
            assert_equal(1, @rs2["result"], "ʹ�ú�����пո������ע��ʱ��ע��ʧ��")
        }

    end

    def clearup
        operate("1.�ָ�Ĭ������") {
                @iam_obj.usr_delete_usr(@tc_user_name_1.strip, @tc_user_pwd)
                @iam_obj.usr_delete_usr(@tc_user_name_2.strip, @tc_user_pwd)
        }
    end

}
