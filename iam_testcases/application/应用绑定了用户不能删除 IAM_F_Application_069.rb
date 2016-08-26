#
# description:
# author:lilupng
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_069", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_app_usr      = "autotest_new"
        @tc_app_provider = "autotest"
        @tc_app_red_uri  = "http://192.168.10.9"
        @tc_err_code     = "22015"
    end

    def process

        operate("1��ssh��¼IAM��������") {
            @res = @iam_obj.manager_login #����Ա��¼->�õ�uid��token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
        }

        operate("2����ȡ֪·����Աtokenֵ��") {
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("3����ȡҪɾ��Ӧ��ID�ţ����и�Ӧ���Ѱ��û���") {
            p "����һ����Ӧ��".encode("GBK")
            args = {"name"=>@tc_app_usr, "provider"=>@tc_app_provider, "redirect_uri"=>@tc_app_red_uri, "comments"=>""}
            rs   = @iam_obj.create_apply(@admin_id, @admin_token, args)
            assert_equal(1, rs["result"], "����Ӧ��ʧ�ܣ�")

            # ��ȡӦ��ID
            @client_id = @iam_obj.get_client_id(@tc_app_usr, @admin_token, @admin_id)
            # Ӧ�ð��û�
            p "�û���¼�����û�Id��Token".encode("GBK")
            rs = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @usr_id = rs["uid"]
            @usr_token = rs["access_token"]
            p "Ӧ�ð��û�".encode("GBK")
            data = "{\"client_id\":\"#{@client_id}\"}"
            rs_bind = @iam_obj.usr_binding_app(@usr_token, @usr_id, data)
            assert_equal(1, rs_bind["result"], "Ӧ�ð��û�ʧ�ܣ�")
        }

        operate("4��ɾ����Ӧ�ã�") {
            rs_del = @iam_obj.del_apply(@tc_app_usr, @admin_token, @admin_id)
            assert_equal(@tc_err_code, rs_del["err_code"], "ɾ��Ӧ��ʧ�ܺ󷵻صĴ����벻��ȷ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            p "Ӧ�ý���û�".encode("GBK")
            data = "{\"client_id\":\"#{@client_id}\"}"
            @iam_obj.usr_unbinding_app(@usr_token, @usr_id, data)

            p "ɾ��Ӧ��".encode("GBK")
            @iam_obj.del_apply(@tc_app_usr, @admin_token, @admin_id)
        }
    end

}
