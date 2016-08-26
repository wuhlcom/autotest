#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_054", "level" => "P3", "auto" => "n"}

    def prepare
        @rs                  = ""
        @tc_app_redirect_uri = "http://www.BAIDU.com"
        @tc_err_code         = "22011"
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

        operate("3����ȡ�޸�Ӧ�õ�Ӧ��ID��;") {
            @client_id = @iam_obj.get_client_id(@ts_app_name_001, @admin_token, @admin_id)
        }

        operate("4���޸�redirect_uri��ַ���д�д��ĸ��") {
            args = {"name"=>"#{@ts_app_name_001}","provider"=>"#{@ts_app_provider_001}","redirect_uri"=>"#{@tc_app_redirect_uri}","comments"=>"#{@ts_app_comments_default_001}"}
            p @rs = @iam_obj.modify_apply(@admin_id, @admin_token, @client_id, args)
            assert_equal(@tc_err_code, @rs["err_code"], "modify apply redirect_uri error��#{@rs["err_desc"]}")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                args = {"name"=>"#{@ts_app_name_001}","provider"=>"#{@ts_app_provider_001}","redirect_uri"=>"#{@ts_app_redirect_uri}","comments"=>"#{@ts_app_comments_default_001}"}
                @iam_obj.modify_apply(@admin_id, @admin_token, @client_id, args)
            end
        }
    end

}
