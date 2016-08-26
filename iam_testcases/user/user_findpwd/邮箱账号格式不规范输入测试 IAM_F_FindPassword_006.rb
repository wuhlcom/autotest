#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_006", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_usr_email1 = "@zhilutec.com"
        @tc_usr_email2 = "zhilu@.com"
        @tc_usr_email3 = "zhilu@zhilutec."
        @tc_usr_email4 = "zhilu@zhilutec..com"
        @tc_usr_email5 = "zhilu@@zhilutec.com"
        @tc_err_code   = "5001"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2�����������ʽ���淶��") {

            rs = @iam_obj.find_pwd_for_email(@tc_usr_email1)
            assert_equal(@tc_err_code, rs["err_code"], "��ʽ����ȷ�������˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")

            rs = @iam_obj.find_pwd_for_email(@tc_usr_email2)
            assert_equal(@tc_err_code, rs["err_code"], "��ʽ����ȷ�������˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")

            rs = @iam_obj.find_pwd_for_email(@tc_usr_email3)
            assert_equal(@tc_err_code, rs["err_code"], "��ʽ����ȷ�������˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")

            rs = @iam_obj.find_pwd_for_email(@tc_usr_email4)
            assert_equal(@tc_err_code, rs["err_code"], "��ʽ����ȷ�������˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")

            rs = @iam_obj.find_pwd_for_email(@tc_usr_email5)
            assert_equal(@tc_err_code, rs["err_code"], "��ʽ����ȷ�������˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
