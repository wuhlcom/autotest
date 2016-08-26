#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_033", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_phone_num = "15814037401"
        @tc_phone_pw  = "123123"
        @tc_err_code  = "11002"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ�ֻ���֤�룻") {
            rs    = @iam_obj.request_mobile_code(@tc_phone_num)
            @code = rs["code"]
            p "�ֻ���ȡ��ȷ����֤��Ϊ��#{@code}".encode("GBK")
        }

        operate("3���޸����룬��֤���������") {
            err_code = (@code.to_i+1).to_s
            p "�޸�֮�����֤��Ϊ��#{err_code}".encode("GBK")
            rs = @iam_obj.usr_modpw_mobile_bycode(@tc_phone_num, @tc_phone_pw, err_code)
            assert_equal(@tc_err_code, rs["err_code"], "�ֻ�ʹ�ô������֤���һ�����ɹ��������һ�ʧ�ܵ��Ƿ��صĴ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
