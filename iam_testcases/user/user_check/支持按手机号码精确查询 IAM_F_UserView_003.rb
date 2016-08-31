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
            @rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
            assert_equal(@ts_add_rs, @rs["result"], "�û�#{@ts_phone_usr}ע��ʧ��")
        }

        operate("2����ȡ֪·����Աtokenֵ��") {
            @res = @iam_obj.manager_login #����Ա��¼->�õ�uid��token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("3�����ֻ����뾫ȷ��ѯ��") {
            args = {"type" => "account", "cond" => @ts_phone_usr}
            rs   = @iam_obj.get_user_list(@admin_id, @admin_token, args)
            assert_equal(@ts_phone_usr, rs["users"][0]["account"], "δ��ѯ��#{@ts_phone_usr}�û���Ϣ")

            # assert_equal("1", rs["totalRows"], "δ��ѯ���û���Ϣ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
            end
        }
    end

}
