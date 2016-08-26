#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_028", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_phone_num2 = "15814037409"
        @tc_phone_pwd2 = "123 456"
        @tc_err_code   = "5005"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2�������ֻ������ȡ��֤�룻") {
        }

        operate("3��ʹ�ø��ֻ��������ע�ᣬ������пո�") {
            p "�����м��пո�".encode("GBK")
            rs = @iam_obj.register_phoneusr(@tc_phone_num2, @tc_phone_pwd2)
            assert_equal(@tc_err_code, rs["err_code"], "�����м��пո�ʱע��ɹ�����ע��ʧ�ܵ������벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
