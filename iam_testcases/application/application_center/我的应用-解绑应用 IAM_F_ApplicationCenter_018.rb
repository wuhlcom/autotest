#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_ApplicationCenter_018", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_app_name1        = "application1"
        @tc_app_name2        = "application12"
        @tc_app_name3        = "app3"
        @tc_app_name4        = "lication4"
        @tc_app_provider     = "zhilutest"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""
    end

    def process

        operate("1��ssh��¼��������") {
            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args2 = {"name" => @tc_app_name2, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args3 = {"name" => @tc_app_name3, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args4 = {"name" => @tc_app_name4, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs1 = @iam_obj.qca_app(@tc_app_name1, args1, "1")
            assert_equal(1, @rs1["result"], "����Ӧ��1ʧ��")
            @rs2 = @iam_obj.qca_app(@tc_app_name2, args2, "1")
            assert_equal(1, @rs2["result"], "����Ӧ��2ʧ��")
            @rs3 = @iam_obj.qca_app(@tc_app_name3, args3, "1")
            assert_equal(1, @rs3["result"], "����Ӧ��3ʧ��")
            @rs4 = @iam_obj.qca_app(@tc_app_name4, args4, "1")
            assert_equal(1, @rs4["result"], "����Ӧ��4ʧ��")
        }

        operate("2����ȡ��¼�û���tokenֵ��id�ţ�") {
            rs1 = @iam_obj.usr_qb_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name1)
            assert_equal(1, rs1["result"], "�û���Ӧ��1ʧ��")
            rs2 = @iam_obj.usr_qb_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name2)
            assert_equal(1, rs2["result"], "�û���Ӧ��2ʧ��")
            rs3 = @iam_obj.usr_qb_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name3)
            assert_equal(1, rs3["result"], "�û���Ӧ��3ʧ��")
            rs4 = @iam_obj.usr_qb_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name4)
            assert_equal(1, rs4["result"], "�û���Ӧ��4ʧ��")
        }

        operate("3���û���ѯ�ҵ�Ӧ�ã�") {
        }

        operate("4���û����Ӧ�ð󶨣�") {
            @rs1 = @iam_obj.usr_qub_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name1)
            assert_equal(1, @rs1["result"], "�û������Ӧ��1ʧ��")
            @rs2 = @iam_obj.usr_qub_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name2)
            assert_equal(1, @rs2["result"], "�û������Ӧ��2ʧ��")
            @rs3 = @iam_obj.usr_qub_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name3)
            assert_equal(1, @rs3["result"], "�û������Ӧ��3ʧ��")
            @rs4 = @iam_obj.usr_qub_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name4)
            assert_equal(1, @rs4["result"], "�û������Ӧ��4ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            unless @rs1["result"] == 1
                @iam_obj.usr_qub_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name1)
            end
            unless @rs2["result"] == 1
                @iam_obj.usr_qub_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name2)
            end
            unless @rs3["result"] == 1
                @iam_obj.usr_qub_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name3)
            end
            unless @rs4["result"] == 1
                @iam_obj.usr_qub_app(@ts_usr_name, @ts_usr_pwd, @tc_app_name4)
            end

            if @rs1["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name1)
            end
            if @rs2["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name2)
            end
            if @rs3["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name3)
            end
            if @rs4["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name4)
            end
        }
    end

}
