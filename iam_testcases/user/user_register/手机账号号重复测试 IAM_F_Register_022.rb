#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_022", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_phone_num = "15814037406"
        @tc_phone_pwd = "123123"
        @tc_err_code  = "5006"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2�������ֻ������ȡ��֤�룻") {

        }

        operate("3��ʹ�ø��ֻ��������ע�᣻") {
            @rs = @iam_obj.register_phoneusr(@tc_phone_num, @tc_phone_pwd)
            assert_equal(1, @rs["result"], "ʹ���ֻ���ע���û�ʧ��")
        }

        operate("4���ٴ�ʹ�ò���3���ֻ��������ע�᣻") {
            rs = @iam_obj.register_phoneusr(@tc_phone_num, @tc_phone_pwd)
            assert_equal(@tc_err_code, rs["err_code"], "ʹ����ͬ�ֻ���ע���û��ɹ�����ע��ʧ�ܵ������벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num, @tc_phone_pwd)
            end
        }
    end

}
