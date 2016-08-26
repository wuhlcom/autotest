#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_032", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_num     = "15814037400"
        @tc_phone_pw      = "123456"
        @tc_phone_default = "123123"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ�ֻ���֤�룻") {
        }

        operate("3���޸����룻") {
            @rs3 = @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw)
            assert_equal(1, @rs3["result"], "�޸��������ո�ʱ�ɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs3["result"] == 1
                @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_default)
            end
        }
    end

}
