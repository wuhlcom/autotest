#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserView_006", "level" => "P1", "auto" => "n"}

    def prepare

    end

    def process

        operate("1��ssh��¼IAM��������") {
            rs         = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @usr_token = rs["access_token"]
            @usr_id    = rs["uid"]

            @res = @iam_obj.manager_login #����Ա��¼->�õ�uid��token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("2����ȡ֪·����Աtokenֵ��") {
            p "�û���Ӧ��".encode("GBK")
            @client_id = @iam_obj.get_client_id(@ts_app_name_001, @admin_token, @admin_id)
            data       = {"client_id" => @client_id}
            @rs_bind   = @iam_obj.usr_binding_app(@usr_token, @usr_id, data)
            assert_equal(1, @rs_bind["result"], "�û���Ӧ��ʧ��")
        }

        operate("3����Ӧ�þ�ȷ��ѯ��") {
            args = {"type" => "client_name", "cond" => @ts_app_name_001}
            rs   = @iam_obj.get_user_list(@admin_id, @admin_token, args)
            assert_equal(@ts_usr_name, rs["users"][0]["account"], "δ��ѯ�����û�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs_bind["result"] == 1
                data = {"client_id" => @client_id}
                @iam_obj.usr_unbinding_app(@usr_token, @usr_id, data)
            end
        }
    end

}
