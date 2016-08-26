#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_009", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_usr_email = "zh ilu@zhilutec.com"
        @tc_err_code  = "5001"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2�����������м���пո�") {
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email)
            assert_equal(@tc_err_code, rs["err_code"], "���������м���пո�������˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
