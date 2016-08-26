#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_014", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_err_code = "11006"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����¼�û���ȡaccess_tokenֵ��uid�ţ�") {
            rs     = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @uid   = rs["uid"]
            @token = rs["access_token"]
        }

        operate("3���޸����룬������;�����һ����") {
            @rs = @iam_obj.mofify_user_pwd(@ts_usr_pwd, @ts_usr_pwd, @uid, @token)
            assert_equal(@tc_err_code, @rs["err_code"], "������;�����һ��ʱ���޸�����ɹ��������޸�ʧ�ܵ��Ƿ��ش����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
