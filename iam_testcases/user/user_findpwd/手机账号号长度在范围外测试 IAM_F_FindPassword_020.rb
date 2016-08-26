#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_020", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_mod_num1 = "138265454444"
        @tc_mod_num2 = "1382645656"
        @tc_err_code = "5002"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2���ֻ������������11λ����С��11λ��") {
            p "�ֻ����������11λ����".encode("GBK")
            @rs1 = @iam_obj.request_mobile_code(@tc_mod_num1)
            assert_equal(@tc_err_code, @rs1["err_code"], "�������11λ���ֻ��Ż�ȡ��֤��ɹ������߻�ȡʧ�ܵ��Ƿ��صĴ����벻��ȷ")

            p "�ֻ�������С��11λ".encode("GBK")
            @rs2 = @iam_obj.request_mobile_code(@tc_mod_num2)
            assert_equal(@tc_err_code, @rs2["err_code"], "����С��11λ���ֻ��Ż�ȡ��֤��ɹ������߻�ȡʧ�ܵ��Ƿ��صĴ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
