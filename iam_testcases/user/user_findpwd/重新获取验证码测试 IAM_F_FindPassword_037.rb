#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_037", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_num        = "15814037401"
        @tc_phone_pw         = "123456"
        @tc_phone_pw_default = "123123"
        @tc_err_code         = "11002"
        @tc_wait_time        = 120
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ�ֻ���֤�룻") {
            re = @iam_obj.request_mobile_code(@tc_phone_num) #������֤��
            p @code1 = re["code"]
            refute(@code1.nil?, "��ȡ��֤��ʧ��")
        }

        operate("3��2�����Ժ��ٴλ�ȡ��֤�룻") {
            sleep @tc_wait_time
            re     = @iam_obj.request_mobile_code(@tc_phone_num) #������֤��
            @code2 = re["code"]
            refute(@code2.nil?, "��ȡ��֤��ʧ��")
        }

        operate("4��ʹ�õ�һ�ε���֤����������һأ�") {
            p rs = @iam_obj.usr_modpw_mobile_bycode(@tc_phone_num, @tc_phone_pw, @code1)
            assert_equal(@tc_err_code, rs["err_code"], "2���Ӻ�ʹ����֤���һ�����ɹ��������һ�ʧ�ܵ��Ƿ��صĴ����벻��ȷ")
        }

        operate("5��ʹ�õڶ�����֤����������һأ�") {
            p @rs = @iam_obj.usr_modpw_mobile_bycode(@tc_phone_num, @tc_phone_pw, @code2)
            assert_equal(1, @rs["result"], "2���Ӻ�ʹ�õڶ�����֤���һ�����ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw_default)
        }
    end

}
