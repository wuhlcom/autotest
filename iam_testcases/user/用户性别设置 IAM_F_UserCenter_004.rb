#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_004", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_phone_usr   = "15814031512"
        @tc_usr_pw      = "123456"
        @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}
    end

    def process

        operate("1��ssh��¼IAM��������") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")
        }

        operate("2����¼�û���ȡaccess_tokenֵ��uid�ţ�") {
            rs     = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
            @uid   = rs["uid"]
            @token = rs["access_token"]
        }

        operate("3�������û��Ա�") {
            args = {"sex" => 1}
            rs   = @iam_obj.usr_modify(@uid, @token, args)
            assert_equal(1, rs["result"], "�޸��û��Ա�����ʧ�ܣ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
        }
    end

}
