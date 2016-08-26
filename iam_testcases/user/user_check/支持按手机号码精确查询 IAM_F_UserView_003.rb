#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserView_003", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_number = "18814036534"
        @tc_phone_pw     = "123456"
    end

    def process

        operate("1��ssh��¼IAM��������") {
            p "�����ֻ����û�".encode("GBK")
            @re = @iam_obj.register_phoneusr(@tc_phone_number, @tc_phone_pw)
            assert_equal(1, @re["result"], "ע���ֻ��û�ʧ��")
        }

        operate("2����ȡ֪·����Աtokenֵ��") {
            @res = @iam_obj.manager_login #����Ա��¼->�õ�uid��token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("3�����ֻ����뾫ȷ��ѯ��") {
            args = {"type" => "account", "cond" => @tc_phone_number}
            rs   = @iam_obj.get_user_list(@admin_id, @admin_token, args)
            assert_equal("1", rs["totalRows"], "δ��ѯ���û���Ϣ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @re["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_number, @tc_phone_pw)
            end
        }
    end

}
