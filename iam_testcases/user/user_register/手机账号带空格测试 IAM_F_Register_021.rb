#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_021", "level" => "P4", "auto" => "n"}

    def prepare
        # @tc_phone_num1 = " 13823652368"
        @tc_phone_num2 = "13823 652367"
        # @tc_phone_num3 = "13823652367 "
        @tc_err_code   = "5002"
    end

    def process


        operate("1��ssh��¼IAM��������") {

        }

        operate("2�������ֻ�������пո�") {
            # p "�ֻ���ǰ����ո�".encode("GBK")
            # p @rs1 = @iam_obj.request_mobile_code(@tc_phone_num1)
            # assert(@rs1["code"], "ʹ���ֻ���ǰ����ո�ע���û�ʧ��")

            p "�ֻ����м���ո�".encode("GBK")
            p @rs2 = @iam_obj.request_mobile_code(@tc_phone_num2)
            assert(@rs2["code"], "ʹ���ֻ����м���ո�ע���û��ɹ�����ע��ʧ�ܵ������벻��ȷ")

            # p "�ֻ��ź�����ո�".encode("GBK")
            # p @rs3 = @iam_obj.request_mobile_code(@tc_phone_num3)
            # assert(@rs3["code"], "ʹ���ֻ��ź�����ո�ע���û�ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
