#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_ApplicationCenter_016", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_app_name1        = "lication4"
        @tc_app_provider     = "zhilutest"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""
    end

    def process

        operate("1��ssh��¼��������") {
            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs1  = @iam_obj.qca_app(@tc_app_name1, args1, "1")
            assert_equal(1, @rs1["result"], "����Ӧ��1ʧ��")
        }

        operate("2����ȡӦ�õ�ID�ţ�") {

        }

        operate("3����ȡ��¼�û���tokenֵ��id�ţ�") {
        }

        operate("4���û���Ӧ�ã�") {
            @rss1 = @iam_obj.usr_qb_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name1)
            assert_equal(1, @rss1["result"], "�û���Ӧ��1ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rss1["result"] == 1
                @iam_obj.usr_qub_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name1)
            end

            if @rs1["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name1)
            end
        }
    end

}
