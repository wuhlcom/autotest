#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_039", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_phone_num1 = "15814037401"
        @tc_phone_num2 = "15814037402"
        @tc_phone_pw   = "123456"
        @tc_err_code   = "11002"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2���ֻ���A��ȡ�ֻ���֤�룻") {
            re = @iam_obj.request_mobile_code(@tc_phone_num1) #������֤��
            @code1 = re["code"]
            refute(@code1.nil?, "��ȡ��֤��ʧ��")
        }

        operate("3���ֻ���B�޸����룬��֤�������ֻ���A����֤�룻") {
            rs = @iam_obj.usr_modpw_mobile_bycode(@tc_phone_num2, @tc_phone_pw, @code1)
            assert_equal(@tc_err_code, rs["err_code"], "ͨ�������ֻ���ȡ����֤���һ�����ɹ��������һ�ʧ�ܵ��Ƿ��صĴ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
