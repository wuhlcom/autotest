#
# description:
# author:liiluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_015", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_new_pwd = "123456"
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

        operate("4��ʹ���������¼��") {
            rs = @iam_obj.user_login(@ts_usr_name, @tc_new_pwd)
            assert_equal(1, rs["result"], "ʹ���������¼ʧ��")
            @new_uid   = rs["uid"]
            @new_token = rs["access_token"]
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                @iam_obj.mofify_user_pwd(@tc_new_pwd, @ts_usr_pwd, @new_uid, @new_token)
            end
        }
    end

}
