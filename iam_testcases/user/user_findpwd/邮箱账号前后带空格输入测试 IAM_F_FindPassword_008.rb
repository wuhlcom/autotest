#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_008", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_usr_email1 = " zhilu@zhilutec.com"
        @tc_usr_email2 = "zhilu@zhilutec.com "
        @tc_err_code  = "11004"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����������ǰ����пո�") {
            p "��������ǰ���пո�".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email1)
            assert_equal(@tc_err_code, rs["err_code"], "��������ǰ���пո�������˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
            p "�����������пո�".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email2)
            assert_equal(@tc_err_code, rs["err_code"], "�����������пո�������˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
