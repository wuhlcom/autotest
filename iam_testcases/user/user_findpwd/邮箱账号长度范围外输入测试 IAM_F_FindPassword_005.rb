#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_005", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_usr_email = "zhilukeji1zhilukeji1@zhilutec.com"
        @tc_err_code   = "11004"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2���������䳤���ڷ�Χ�⣻") {
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email)
            assert_equal(@tc_err_code, rs["err_code"], "����Ϊ33��ף���������˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
