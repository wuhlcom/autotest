#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserView_002", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_phone_number1 = "18814036543"
        @tc_phone_number2 = "18814036534"
        @tc_phone_pw     = "123456"
    end

    def process

        operate("1��ssh��¼IAM��������") {
            p "�����ֻ����û�".encode("GBK")
            @re = @iam_obj.register_phoneusr(@tc_phone_number1, @tc_phone_pw)
            assert_equal(1, @re["result"], "ע���ֻ��û�ʧ��")
            @re1 = @iam_obj.register_phoneusr(@tc_phone_number2, @tc_phone_pw)
            assert_equal(1, @re["result"], "ע���ֻ��û�ʧ��")
        }

        operate("2����ȡ֪·����Աtokenֵ��") {
            @res = @iam_obj.manager_login #����Ա��¼->�õ�uid��token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("3�����ֻ�����ģ����ѯ��") {
            str = @tc_phone_number1[0]+@tc_phone_number1[1]+@tc_phone_number1[2]
            args = {"type" => "account", "cond" => str}
            rs   = @iam_obj.get_user_list(@admin_id, @admin_token, args)
            refute(rs["users"].empty?, "δ��ѯ���û���Ϣ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @re["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_number1, @tc_phone_pw)
            end

            if @re1["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_number2, @tc_phone_pw)
            end
        }
    end

}
