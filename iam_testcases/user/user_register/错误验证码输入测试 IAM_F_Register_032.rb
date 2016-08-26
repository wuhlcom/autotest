#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_032", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_phone_num     = "15814236543"
        @tc_phone_pwd     = "123456"
        @tc_register_type = "phone"
        @tc_err_code      = "11002"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2�������ֻ������ȡ��֤�룻") {
        }

        operate("3��ʹ�ø��ֻ��������ע�ᣬ���������֤�룻") {
            re   = @iam_obj.request_mobile_code(@tc_phone_num) #������֤��
            code = re["code"]
            refute(code.nil?, "��ȡ��֤��ʧ��")

            code = code+1
            rs   = @iam_obj.register_user(@tc_phone_num, @tc_phone_pwd, @tc_register_type, code)
            assert_equal(@tc_err_code, rs["err_code"], "ʹ�ô������֤��ע���û��ɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
