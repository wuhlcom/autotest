#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_ApplicationCenter_003", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_app_name1        = "autotest_app1"
        @tc_app_name2        = "autotest_app2"
        @tc_app_provider     = "zhilutest"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""
        @tc_app_comments_ch  = "HaHaHaHa"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼�û���tokenֵ��id�ţ�") {
            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args2 = {"name" => @tc_app_name2, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs1  = @iam_obj.qca_app(@tc_app_name1, args1, "1")
            assert_equal(1, @rs1["result"], "����Ӧ��1������ʧ��")
            @rs2 = @iam_obj.qca_app(@tc_app_name2, args2, "1")
            assert_equal(1, @rs2["result"], "����Ӧ��2������ʧ��")
        }

        operate("3���û���ѯ���󶨵�Ӧ���б�") {

        }

        operate("4��֪·����ԱԱ�޸�Ӧ����Ϣ��") {
            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments_ch}
            rs1 = @iam_obj.mana_mod_app(@tc_app_name1, args1)
            assert_equal(1, rs1["result"], "�޸�Ӧ��1��Ϣʧ��")
            args2 = {"name" => @tc_app_name2, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments_ch}
            rs2 = @iam_obj.mana_mod_app(@tc_app_name2, args2)
            assert_equal(1, rs2["result"], "�޸�Ӧ��2��Ϣʧ��")
        }

        operate("5���û���ѯ���󶨵�Ӧ���б�") {
            rs1 = @iam_obj.check_app_details(@tc_app_name1)
            assert_equal(@tc_app_comments_ch, rs1["comments"], "Ӧ��1��ѯ�ɹ�")
            rs2 = @iam_obj.check_app_details(@tc_app_name2)
            assert_equal(@tc_app_comments_ch, rs2["comments"], "Ӧ��2��ѯ�ɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs1["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name1)
            end
            if @rs2["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name2)
            end
        }
    end

}
