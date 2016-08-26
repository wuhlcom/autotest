#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_004", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_usr_email1 = "abc@163.com"
        @tc_usr_email2 = "abc@qq.com"
        @tc_usr_email3 = "abc@yahoo.com"
        @tc_usr_email4 = "abc@gmail.com"
        @tc_usr_email5 = "abc@hotmail.com"
        @tc_usr_email6 = "zhilukeji1zhilukeji@zhilutec.com"
        @tc_usr_email7 = "zhilu123_123@zhilutec.com"
        @tc_err_code   = "11004"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2������һ�������˺ţ�") {
            p "�����ע���163�����˺�".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email1)
            assert_equal(@tc_err_code, rs["err_code"], "��ע���163�����˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
            p "�����ע���qq�����˺�".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email2)
            assert_equal(@tc_err_code, rs["err_code"], "��ע���qq�����˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
            p "�����ע���yahoo�����˺�".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email3)
            assert_equal(@tc_err_code, rs["err_code"], "��ע���yahoo�����˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
            p "�����ע���gamil�����˺�".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email4)
            assert_equal(@tc_err_code, rs["err_code"], "��ע���gmail�����˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
            p "�����ע���hotmail�����˺�".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email5)
            assert_equal(@tc_err_code, rs["err_code"], "��ע���hotmail�����˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
            p "�����ע���32λ�ַ����ȵ������˺�".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email6)
            assert_equal(@tc_err_code, rs["err_code"], "��ע���32λ�ַ����ȵ������˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
            p "�����ע��Ĵ��»��ߵ������˺�".encode("GBK")
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email7)
            assert_equal(@tc_err_code, rs["err_code"], "��ע��Ĵ��»��ߵ������˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
