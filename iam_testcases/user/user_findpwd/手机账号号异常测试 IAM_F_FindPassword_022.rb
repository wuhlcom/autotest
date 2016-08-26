#
# description:
# author:liiluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_022", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_mod_num1 = "1382365236��"
        @tc_mod_num2 = "1382365test"
        @tc_mod_num3 = "138~!@#$%^&"
        @tc_mod_num4 = "138������������12"
        @tc_err_code = "5002"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2�������ֻ��Ŵ������ġ���ĸ����ȫ�Ǹ�ʽ���֣�") {
            p "�ֻ�����������ĺ���".encode("GBK")
            @rs1 = @iam_obj.request_mobile_code(@tc_mod_num1)
            assert_equal(@tc_err_code, @rs1["err_code"], "�ֻ�����������ĺ���ʱ��ȡ��֤��ɹ������߻�ȡʧ�ܵ��Ƿ��صĴ����벻��ȷ")
            p "�ֻ��������Ӣ����ĸ".encode("GBK")
            @rs1 = @iam_obj.request_mobile_code(@tc_mod_num2)
            assert_equal(@tc_err_code, @rs1["err_code"], "�ֻ��������Ӣ����ĸʱ��ȡ��֤��ɹ������߻�ȡʧ�ܵ��Ƿ��صĴ����벻��ȷ")
            p "�ֻ�������������ַ�".encode("GBK")
            @rs1 = @iam_obj.request_mobile_code(@tc_mod_num3)
            assert_equal(@tc_err_code, @rs1["err_code"], "�ֻ�������������ַ�ʱ��ȡ��֤��ɹ������߻�ȡʧ�ܵ��Ƿ��صĴ����벻��ȷ")
            p "�ֻ��������ȫ�Ǹ�ʽ������".encode("GBK")
            @rs1 = @iam_obj.request_mobile_code(@tc_mod_num4)
            assert_equal(@tc_err_code, @rs1["err_code"], "�ֻ��������ȫ�Ǹ�ʽ������ʱ��ȡ��֤��ɹ������߻�ȡʧ�ܵ��Ƿ��صĴ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
