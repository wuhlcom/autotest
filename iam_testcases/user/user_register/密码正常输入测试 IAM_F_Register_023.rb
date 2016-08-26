#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_023", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_num1 = "15814037409"
        @tc_phone_num2 = "15814037407"
        @tc_phone_num3 = "15814037408"
        @tc_phone_pwd1 = "123123"
        @tc_phone_pwd2 = "aa12347890aa12347890aa1234789012"
        @tc_phone_pwd3 = "123__22Aa"
        @tc_err_code   = "5006"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2�������ֻ������ȡ��֤�룻") {

        }

        operate("3��ʹ�ø��ֻ��������ע�ᣬ�����������룻") {
            p "�������������6���ַ�".encode("GBK")
            @rs1 = @iam_obj.register_phoneusr(@tc_phone_num1, @tc_phone_pwd1)
            assert_equal(1, @rs1["result"], "ʹ���ֻ���ע���û�ʧ��")

            p "���������������32���ַ��������ֺ���ĸ".encode("GBK")
            @rs2 = @iam_obj.register_phoneusr(@tc_phone_num2, @tc_phone_pwd2)
            assert_equal(1, @rs2["result"], "ʹ���ֻ���ע���û�ʧ��")

            p "�����������������»����ַ�".encode("GBK")
            @rs3 = @iam_obj.register_phoneusr(@tc_phone_num3, @tc_phone_pwd3)
            assert_equal(1, @rs3["result"], "ʹ���ֻ���ע���û�ʧ��")
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
            if @rs3["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num3, @tc_phone_pwd3)
            end
        }
    end

}
