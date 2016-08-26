#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_033", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_num1    = "15814236543"
        @tc_phone_num2    = "15814235682"
        @tc_phone_pwd     = "123456"
        @tc_register_type = "phone"
        @tc_err_code      = "11002"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2�������ֻ������ȡ��֤�룻") {
            re    = @iam_obj.request_mobile_code(@tc_phone_num1) #������֤��
            @code = re["code"]
            refute(@code.nil?, "��ȡ��֤��ʧ��")
        }

        operate("3��ʹ�ø��ֻ��������ע�ᣬ�������֤�룻") {
            @rs1 = @iam_obj.register_user(@tc_phone_num1, @tc_phone_pwd, @tc_register_type, @code)
            assert_equal(1, @rs1["result"], "ʹ����ȷ����֤��ע���û�ʧ��")
        }

        operate("4��ʹ������һ���ֻ������벽��2��ȡ������֤�����ע�᣻") {
            re   = @iam_obj.request_mobile_code(@tc_phone_num2) #������֤��
            code = re["code"]
            refute(code.nil?, "��ȡ��֤��ʧ��")

            @rs2 = @iam_obj.register_user(@tc_phone_num2, @tc_phone_pwd, @tc_register_type, @code)
            assert_equal(@tc_err_code, @rs2["err_code"], "ʹ�ô������֤��ע���û��ɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs1["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num1, @tc_phone_pwd)
            end
            if @rs2["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num2, @tc_phone_pwd)
            end
        }
    end

}
