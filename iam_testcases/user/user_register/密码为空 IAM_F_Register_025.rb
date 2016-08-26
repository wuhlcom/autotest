#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_025", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_phone_num = "15814037408"
        @tc_phone_pwd = ""
        @tc_err_code  = "5005"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2�������ֻ������ȡ��֤�룻") {
        }

        operate("3��ʹ�ø��ֻ��������ע�ᣬ����Ϊ�գ�") {
            rs = @iam_obj.register_phoneusr(@tc_phone_num, @tc_phone_pwd)
            assert_equal(@tc_err_code, rs["err_code"], "����Ϊ��ʱע��ɹ�����ע��ʧ�ܵ������벻��ȷ")

        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
