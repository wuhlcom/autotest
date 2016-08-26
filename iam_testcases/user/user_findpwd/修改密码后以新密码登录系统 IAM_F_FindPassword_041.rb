#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_041", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_num        = "15814037400"
        @tc_phone_pw         = "123456"
        @tc_phone_pw_default = "123123"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ�ֻ���֤�룻") {
        }

        operate("3���޸����룻") {
            @rs = @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw)
            assert_equal(1, @rs["result"], "�޸�����ʧ�ܣ�")
        }

        operate("4��ʹ���������¼��") {
            rs = @iam_obj.user_login(@tc_phone_num, @tc_phone_pw)
            assert_equal(1, rs["result"], "�޸������ʹ���������¼ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw_default)
            end
        }
    end

}
