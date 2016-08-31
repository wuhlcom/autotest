#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_037", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_err_code  = "11002"
        @tc_wait_time = 125 #���ӳ٣�����5s
    end

    def process

        operate("1��ssh��¼IAM��������") {
            rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "�û�#{@ts_phone_usr}ע��ʧ��")
        }

        operate("2����ȡ�ֻ���֤�룻") {
            re = @iam_obj.request_mobile_code(@ts_phone_usr) #������֤��
            @code1 = re["code"]
            refute(@code1.nil?, "��ȡ��֤��ʧ��")
        }

        operate("3��2�����Ժ��ٴλ�ȡ��֤�룻") {
            sleep @tc_wait_time
            re     = @iam_obj.request_mobile_code(@ts_phone_usr) #������֤��
            @code2 = re["code"]
            refute(@code2.nil?, "��ȡ��֤��ʧ��")
        }

        operate("4��ʹ�õ�һ�ε���֤����������һأ�") {
            rs = @iam_obj.usr_modpw_mobile_bycode(@ts_phone_usr, @ts_usr_pw, @code1)
            assert_equal(@tc_err_code, rs["err_code"], "2���Ӻ�ʹ����֤���һ�����ɹ��������һ�ʧ�ܵ��Ƿ��صĴ����벻��ȷ")
        }

        operate("5��ʹ�õڶ�����֤����������һأ�") {
            @rs = @iam_obj.usr_modpw_mobile_bycode(@ts_phone_usr, @ts_usr_pw, @code2)
            assert_equal(@ts_add_rs, @rs["result"], "2���Ӻ�ʹ�õڶ�����֤���һ�����ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
        }
    end

}
