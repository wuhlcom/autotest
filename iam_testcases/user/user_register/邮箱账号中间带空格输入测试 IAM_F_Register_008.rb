#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_008", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_user_name_1   = "zh ilu@zhilutec.com"
        @tc_user_pwd      = "123123"
        @tc_register_type = "email"
        @tc_err_code      = "5003"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2��ע�������м���пո�") {
            rs = @iam_obj.register_user(@tc_user_name_1, @tc_user_pwd, @tc_register_type)
            assert_equal(@tc_err_code, rs["err_code"], "ʹ�������м���ո�ע��ɹ�����ע��ʧ�ܴ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
