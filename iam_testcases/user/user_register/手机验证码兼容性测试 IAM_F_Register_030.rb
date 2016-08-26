#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_030", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_mobile_phone  = "15815642765"
        @tc_telecom_phone = "18015642765"
        @tc_unicom_phone  = "18615642765"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2���ֱ�ʹ����ͨ�����š��ƶ��ֻ����������֤���ȡ���ԣ�") {
            p "ʹ���ƶ�����".encode("GBK")
            rs = @iam_obj.request_mobile_code(@tc_mobile_phone)
            assert(rs["mobile"] == @tc_mobile_phone && !rs["code"].nil?, "�ƶ������ȡ��֤��ʧ��")
            p "ʹ�õ��ź���".encode("GBK")
            rs = @iam_obj.request_mobile_code(@tc_telecom_phone)
            assert(rs["mobile"] == @tc_telecom_phone && !rs["code"].nil?, "�ƶ������ȡ��֤��ʧ��")
            p "ʹ����ͨ����".encode("GBK")
            rs = @iam_obj.request_mobile_code(@tc_unicom_phone)
            assert(rs["mobile"] == @tc_unicom_phone && !rs["code"].nil?, "�ƶ������ȡ��֤��ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
