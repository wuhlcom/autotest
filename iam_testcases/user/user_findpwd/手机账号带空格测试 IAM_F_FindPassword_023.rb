#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_023", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_mod_num  = " 13823652367"
        @tc_err_code = "5002"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2���ֻ�����������пո�") {
            @rs1 = @iam_obj.request_mobile_code(@tc_mod_num)
            assert_equal(@tc_err_code, @rs1["err_code"], "�ֻ�����������пո�ʱ��ȡ��֤��ɹ������߻�ȡʧ�ܵ��Ƿ��صĴ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
