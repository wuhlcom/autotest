#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_010", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_user_name_1   = "liluping@zhilutec.com"
        @tc_user_pwd      = "123123"
        @tc_err_code      = "5006"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2��ʹ������ע���û���") {
            @rs1 = @iam_obj.register_emailusr(@tc_user_name_1, @tc_user_pwd, 1)
            assert_equal(1, @rs1["result"], "ʹ����ȷ�ַ�ע��ʱ��ע��ʧ��")
        }

        operate("3���ٴ�ע��һ���û������仹ʹ�ò���2������") {
            @rs2 = @iam_obj.register_emailusr(@tc_user_name_1, @tc_user_pwd, 1)
            assert_equal(@tc_err_code, @rs2["err_code"], "ʹ����ͬ�ַ�ע��ʱ��ע��ɹ����ߴ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs1["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_1, @tc_user_pwd)
            end
        }
    end

}
