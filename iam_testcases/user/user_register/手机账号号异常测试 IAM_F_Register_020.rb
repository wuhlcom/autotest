#
# description: url��֧�֣��ýű�������
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_020", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_phone_num1 = "1382365236��"
        @tc_phone_num2 = "1382365test"
        @tc_phone_num3 = "1382365$"
        @tc_phone_num4 = "138������������12"
        @tc_phone_pwd  = "123123"
        @tc_err_code   = "5002"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2�������쳣�ֻ��������ע�᣻") {
            p "�ֻ�����������ĺ���".encode("GBK")
            p rs = @iam_obj.request_mobile_code(@tc_phone_num1)
            # assert_equal(@tc_err_code, rs["err_code"], "ʹ���ֻ��Ŵ����ĺ���ע���û��ɹ�����ע��ʧ�ܵ������벻��ȷ")
            p "�ֻ��������Ӣ����ĸ".encode("GBK")
            p rs = @iam_obj.request_mobile_code(@tc_phone_num2)
            # assert_equal(@tc_err_code, rs["err_code"], "ʹ���ֻ��Ŵ�Ӣ����ĸע���û��ɹ�����ע��ʧ�ܵ������벻��ȷ")
            p "�ֻ�������������ַ�".encode("GBK")
            p rs = @iam_obj.request_mobile_code(@tc_phone_num3)
            # assert_equal(@tc_err_code, rs["err_code"], "ʹ���ֻ��Ŵ������ַ�ע���û��ɹ�����ע��ʧ�ܵ������벻��ȷ")
            p "�ֻ��������ȫ�Ǹ�ʽ������".encode("GBK")
            p rs = @iam_obj.request_mobile_code(@tc_phone_num4)
            # assert_equal(@tc_err_code, rs["err_code"], "ʹ���ֻ��Ŵ�ȫ�Ǹ�ʽ������ע���û��ɹ�����ע��ʧ�ܵ������벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
