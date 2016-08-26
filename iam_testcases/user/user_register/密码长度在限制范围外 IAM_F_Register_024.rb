#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_024", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_num1 = "15814037407"
        @tc_phone_num2 = "15814037408"
        @tc_phone_pwd1 = "aa123"
        @tc_phone_pwd2 = "aa12347890aa12347890aa12347890123"
        @tc_err_code   = "5005"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2�������ֻ������ȡ��֤�룻") {

        }

        operate("3��ʹ�ø��ֻ��������ע�ᣬ���볤���ڷ�Χ�⣻") {
            p "���������������5���ַ�".encode("GBK")
            @rs1 = @iam_obj.register_phoneusr(@tc_phone_num1, @tc_phone_pwd1)
            assert_equal(@tc_err_code, @rs1["err_code"], "����Ϊ5���ַ�ʱע��ɹ�����ע��ʧ�ܵ������벻��ȷ")

            p "���������������33���ַ�".encode("GBK")
            @rs2 = @iam_obj.register_phoneusr(@tc_phone_num2, @tc_phone_pwd2)
            assert_equal(@tc_err_code, @rs2["err_code"], "����Ϊ33���ַ�ʱע��ɹ�����ע��ʧ�ܵ������벻��ȷ")

        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs1["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num1, @tc_phone_pwd1)
            end
            if @rs2["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num2, @tc_phone_pwd2)
            end
        }
    end

}
