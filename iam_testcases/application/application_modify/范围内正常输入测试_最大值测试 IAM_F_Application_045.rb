#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_045", "level" => "P1", "auto" => "n"}

    def prepare
        @rs = ""
        @tc_app_comments_max = "����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*"+
                               "����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*"+
                               "����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*����24zimu$%^&*��24zi$^*"
        p "comments��������������#{@tc_app_comments_max.size}���ַ���".encode("GBK")
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

        operate("4���޸�commentsΪ��󳤶�ֵ��") {
            args = {"name"=>"#{@ts_app_name_001}","provider"=>"#{@ts_app_provider_001}","redirect_uri"=>"#{@ts_app_redirect_uri}","comments"=>"#{@tc_app_comments_max}"}
            @rs = @iam_obj.modify_apply(@admin_id, @admin_token, @client_id, args)
            assert_equal(1, @rs["result"], "modify apply comments error��#{@rs["err_desc"]}")

            #����Ƿ��޸ĳɹ�
            rs_detail = @iam_obj.apply_details(@client_id, @admin_id, @admin_token)
            assert_equal(@tc_app_comments_max, rs_detail["comments"], "�޸�comments�����ѯδ�޸ĳɹ���")
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
