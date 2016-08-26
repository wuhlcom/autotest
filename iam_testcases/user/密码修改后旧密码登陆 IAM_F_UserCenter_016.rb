#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_016", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_new_pwd  = "123456"
        @tc_err_code = "10001"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����¼�û���ȡaccess_tokenֵ��uid�ţ�") {
            rs     = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @uid   = rs["uid"]
            @token = rs["access_token"]
        }

        operate("3���޸����룻") {
            @rs = @iam_obj.mofify_user_pwd(@ts_usr_pwd, @tc_new_pwd, @uid, @token)
            assert_equal(1, @rs["result"], "�޸�����ʧ��")
        }

        operate("4��ʹ�þ������¼��") {
            rs = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            assert_equal(@tc_err_code, rs["err_code"], "ʹ�þ������¼�ɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                rs = @iam_obj.user_login(@ts_usr_name, @tc_new_pwd)
                @iam_obj.mofify_user_pwd(@tc_new_pwd, @ts_usr_pwd, rs["uid"], rs["access_token"])
            end
        }
    end

}
