#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_006", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_user_name_1   = "zhilu@֪·.com"
        @tc_user_name_2   = "zhilu~#$%@zhilutec.com"
        @tc_user_name_3   = "zhilu@�ڣȣɣ̣�.com"
        @tc_user_pwd      = "123123"
        @tc_register_type = "email"
        @tc_err_code      = "5003"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2��ʹ���쳣��ʽ���������ע�᣻") {
            p "��������ĺ��ֵ��ַ�".encode("GBK")
            rs = @iam_obj.register_user(@tc_user_name_1, @tc_user_pwd, @tc_register_type)
            assert_equal(@tc_err_code, rs["err_code"], "ʹ���쳣��ʽ�ĵ�����ע��ɹ�����ע��ʧ�ܴ����벻��ȷ")
            p "���������������»��������ַ����ַ�".encode("GBK")
            rs = @iam_obj.register_user(@tc_user_name_2, @tc_user_pwd, @tc_register_type)
            assert_equal(@tc_err_code, rs["err_code"], "ʹ���쳣��ʽ�ĵ�����ע��ɹ�����ע��ʧ�ܴ����벻��ȷ")
            p "������������ȫ���ַ����ַ�".encode("GBK")
            rs = @iam_obj.register_user(@tc_user_name_3, @tc_user_pwd, @tc_register_type)
            assert_equal(@tc_err_code, rs["err_code"], "ʹ���쳣��ʽ�ĵ�����ע��ɹ�����ע��ʧ�ܴ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
