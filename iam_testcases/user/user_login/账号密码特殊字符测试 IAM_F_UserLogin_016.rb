#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserLogin_001", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_usr_name = "~!@#$%^&*()_+{}:\"|<>?-=[];'\\,./"
        @tc_usr_pwd = "~!@#$%^&*()_+{}:\"|<>?-=[];'\\,./"
        @tc_err_code = "10001"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2���û���¼���˺š���������Ϊ������ţ�") {
            rs = @iam_obj.user_login(@tc_usr_name, @tc_usr_pwd)
            assert_equal(@tc_err_code, rs["err_code"], "�˺����붼Ϊ�����ַ���¼ʱ��¼�ɹ������ǵ�¼ʧ�ܵ��Ƿ��صĴ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
