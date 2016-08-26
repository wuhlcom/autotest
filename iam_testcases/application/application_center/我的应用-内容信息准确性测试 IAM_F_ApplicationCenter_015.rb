#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_ApplicationCenter_015", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_app_name1        = "lication4"
        @tc_app_provider     = "zhilutest"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""
    end

    def process

        operate("1��ssh��¼IAM��������") {
            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs1  = @iam_obj.qca_app(@tc_app_name1, args1, "1")
            assert_equal(1, @rs1["result"], "����Ӧ��1ʧ��")
        }

        operate("2����ȡ��¼�û���tokenֵ��id�ţ�") {
        }

        operate("3���û���ѯ���󶨵�Ӧ���б�") {
            rs = @iam_obj.usr_login_list_app_all(@ts_usr_name, @ts_usr_pwd)
            assert_equal(@tc_app_name1, rs["apps"][0]["name"], "��ѯ���󶨵�Ӧ���б�ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs1["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name1)
            end
        }
    end

}
