#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_018", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_pwd_old = "123456"
        @tc_pwd_new = "12345678"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ�ֻ���֤�룻") {

        }

        operate("3���޸����룻") {
            @rs = @iam_obj.usr_modpw_mobile(@ts_usr_name, @tc_pwd_new)
            assert_equal(1, @rs["result"], "�ֻ��޸�����ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                @iam_obj.usr_modpw_mobile(@ts_usr_name, @tc_pwd_old)
            end
        }
    end

}
