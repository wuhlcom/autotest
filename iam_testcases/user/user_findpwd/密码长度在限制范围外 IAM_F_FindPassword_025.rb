#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_025", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_num     = "15814037401"
        @tc_phone_pw1     = "aa123"
        @tc_phone_pw2     = "aa12347890aa12347890aa12347890123"
        @tc_phone_default = "123123"
        @tc_error_code    = "5005"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ�ֻ���֤�룻") {
        }

        operate("3���޸����볤���ڷ�Χ�⣻") {
            p "����Ϊ5���ַ�".encode("GBK")
            @rs1 = @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw1)
            assert_equal(@tc_error_code, @rs1["err_code"], "�޸�����Ϊ5���ַ�ʱ�ɹ�")
            p "����Ϊ33���ַ�".encode("GBK")
            @rs2 = @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw2)
            assert_equal(@tc_error_code, @rs2["err_code"], "�޸�����Ϊ33���ַ�ʱ�ɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs1["result"] == 1 || @rs2["result"] == 1
                @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_default)
            end
        }
    end

}
