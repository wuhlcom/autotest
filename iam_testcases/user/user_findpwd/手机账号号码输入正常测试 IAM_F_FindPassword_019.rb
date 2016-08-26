#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_019", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_mod_number = "15812345678"
        @tc_pwd_old    = "123456"
        @tc_pwd_new    = "12345678"
        @tc_err_code   = "2002"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ�ֻ���֤�룻") {
        }

        operate("3���һ����룻") {
            @rs = @iam_obj.usr_modpw_mobile(@tc_mod_number, @tc_pwd_new)
            assert_equal(@tc_err_code, @rs["err_code"], "����11λδע����ֻ����һ�����ɹ��������һ�ʧ�ܵ��Ƿ��صĴ����벻��ȷ")

        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                @iam_obj.usr_modpw_mobile(@tc_mod_number, @tc_pwd_old)
            end
        }
    end

}
