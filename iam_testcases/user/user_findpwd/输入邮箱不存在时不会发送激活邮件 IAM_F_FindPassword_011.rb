#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_011", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_usr_email = "bucunzai@zhilutec.cOm"
        @tc_err_code  = "11004"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2������һ�����������䣻") {
            rs = @iam_obj.find_pwd_for_email(@tc_usr_email)
            assert_equal(@tc_err_code, rs["err_code"], "���벻���ڵĵ������˺��һ�����ɹ������һ�ʧ�ܵ��Ǵ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
