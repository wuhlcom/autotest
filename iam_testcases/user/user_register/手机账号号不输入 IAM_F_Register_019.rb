#
# description: ע���û�
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_019", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_phone_num = ""
        @tc_err_code  = "9001"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2���ֻ���������Ϊ��") {
            rs = @iam_obj.request_mobile_code(@tc_phone_num)
            assert_equal(@tc_err_code, rs["err_code"], "ʹ�ÿ��ֻ�����ע���û��ɹ�����ע��ʧ�ܵ������벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
