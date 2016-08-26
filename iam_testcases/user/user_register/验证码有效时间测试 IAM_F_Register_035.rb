#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_035", "level" => "P3", "auto" => "n"}

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
            re    = @iam_obj.request_mobile_code(@tc_phone_num) #������֤��
            @code = re["code"]
            refute(@code.nil?, "��ȡ��֤��ʧ��")
        }

        operate("3��2�����Ժ�ʹ�ø��ֻ��������ע�ᣬ�������֤�룻") {
            sleep 125 #���ӳ٣�����5s
            @rs   = @iam_obj.register_user(@tc_phone_num, @tc_phone_pwd, @tc_register_type, @code)
            assert_equal(@tc_err_code, @rs["err_code"], "�ȴ�2���Ӻ�ע���û��ɹ�����ע��ʧ�ܵ�����֤�����")
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
