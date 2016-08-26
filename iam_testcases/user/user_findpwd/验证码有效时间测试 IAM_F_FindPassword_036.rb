#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_036", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_num = "15814037400"
        @tc_phone_pw  = "123123"
        @tc_err_code  = "11003"
        @tc_wait_time = 125 #���ӳ٣�����5s
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ�ֻ���֤�룻") {
            re    = @iam_obj.request_mobile_code(@tc_phone_num) #������֤��
            p @code = re["code"]
            refute(@code.nil?, "��ȡ��֤��ʧ��")
        }

        operate("3��2�����Ժ���������һأ�") {
            sleep @tc_wait_time
            rs       = @iam_obj.usr_modpw_mobile_bycode(@tc_phone_num, @tc_phone_pw, @code)
            assert_equal(@tc_err_code, rs["err_code"], "2���Ӻ�ʹ����֤���һ�����ɹ��������һ�ʧ�ܵ��Ƿ��صĴ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
