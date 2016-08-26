#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_004", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_user_name_33      = "zhilukeji1zhilukejif@zhilutec.com"
        @tc_user_pwd          = "123123"
        @tc_register_type     = "email"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2��ʹ������ע���û������䳤��33�ַ���") {
            rs = @iam_obj.register_user(@tc_user_name_33, @tc_user_pwd, @tc_register_type)
            refute_equal(1, rs["result"], "ʹ�ó��ȳ���33���ַ����û���ע������ɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
