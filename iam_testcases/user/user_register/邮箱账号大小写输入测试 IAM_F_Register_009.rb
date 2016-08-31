#
# description:
# author:lilupng
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_009", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_user_name_1 = "NIDAYE@SOHU.COM"
        @tc_user_name_2 = "nidaye@qq.com"
        @tc_user_name_3 = "nIdAYe@163.cOm"
        @tc_user_pwd    = "123123"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2��ע�������˺ź��д�Сд��ĸ��") {
            p "������ĸȫ����д���ַ�".encode("GBK")
            p @rs1 = @iam_obj.register_emailusr(@tc_user_name_1, @tc_user_pwd, 1)
            assert_equal(1, @rs1["result"], "ʹ����ĸȫ����д���ַ�ע��ʱ��ע��ʧ��")

            p "������ĸȫ��Сд���ַ�".encode("GBK")
            p @rs2 = @iam_obj.register_emailusr(@tc_user_name_2, @tc_user_pwd, 1)
            assert_equal(1, @rs2["result"], "ʹ����ĸȫ��Сд���ַ�ע��ʱ��ע��ʧ��")

            p "������ĸ��Сд��ϵ��ַ�".encode("GBK")
            p @rs3 = @iam_obj.register_emailusr(@tc_user_name_3, @tc_user_pwd, 1)
            assert_equal(1, @rs3["result"], "ʹ����ĸ��Сд��ϵ��ַ�ע��ʱ��ע��ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.usr_delete_usr(@tc_user_name_1, @tc_user_pwd)
            @iam_obj.usr_delete_usr(@tc_user_name_2, @tc_user_pwd)
            @iam_obj.usr_delete_usr(@tc_user_name_3, @tc_user_pwd)
        }
    end

}
