#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_018", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_num_12 = "158140374001"
        @tc_phone_num_10 = "1581403740"
        @tc_err_code     = "5002"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2���ֻ����볤�ȴ���11λ����С��11λ��") {
            p "ʹ��12λ����".encode("GBK")
            rs = @iam_obj.request_mobile_code(@tc_phone_num_12)
            assert_equal(@tc_err_code, rs["err_code"], "ʹ���ֻ����볤�ȴ���11λע���û��ɹ�����ע��ʧ�ܵ������벻��ȷ")
            p "ʹ��10λ����".encode("GBK")
            rs = @iam_obj.request_mobile_code(@tc_phone_num_10)
            assert_equal(@tc_err_code, rs["err_code"], "ʹ���ֻ����볤��С��11λע���û��ɹ�����ע��ʧ�ܵ������벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
