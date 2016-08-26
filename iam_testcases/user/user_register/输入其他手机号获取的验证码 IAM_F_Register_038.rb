#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_038", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_phone_num1    = "15814236543"
        @tc_phone_num2    = "15814235615"
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
            @rs = @iam_obj.register_user(@tc_phone_num1, @tc_phone_pwd, @tc_register_type, @code)
            assert_equal(1, @rs["result"], "ע��ʧ��!")
        }

        operate("4��ʹ������һ���ֻ������벽��2��ȡ������֤�����ע�᣻") {
            @rs1 = @iam_obj.register_user(@tc_phone_num2, @tc_phone_pwd, @tc_register_type, @code)
            assert_equal(@tc_err_code, @rs1["err_code"], "ע��ɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num1, @tc_phone_pwd)
            end
            if @rs1["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num2, @tc_phone_pwd)
            end
        }
    end

}
