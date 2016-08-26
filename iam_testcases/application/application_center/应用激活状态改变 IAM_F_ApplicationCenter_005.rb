#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_ApplicationCenter_005", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_manager_name     = "super@zhilutec.com"
        @tc_manager_nickname = "SUPER_MAN"
        @tc_manager_pwd      = "123456"

        @tc_app_name1        = "autotest_app1"
        @tc_app_name2        = "autotest_app2"
        @tc_app_name3        = "autotest_app3"
        @tc_app_name4        = "autotest_app4"
        @tc_app_provider     = "zhilutest"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""
    end

    def process

        operate("1��ssh��¼IAM��������") {
            @rs  = {}
            @rs1 = {}
            @rs2 = {}
            @rs3 = {}
            @rs4 = {}
        }

        operate("2����ȡ��¼�û���tokenֵ��id�ţ�") {
            @rs = @iam_obj.manager_add(@tc_manager_name, @tc_manager_nickname, @tc_manager_pwd)
            assert_equal(1, @rs["result"], "������������Աʧ��")

            p "֪·��������Ա����Ӧ�ã�������".encode("GBK")
            args1 = {"name" => @tc_app_name1, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args2 = {"name" => @tc_app_name2, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs1 = @iam_obj.qca_app(@tc_app_name1, args1, "1")
            assert_equal(1, @rs1["result"], "����Ӧ��1ʧ��")
            @rs2 = @iam_obj.qca_app(@tc_app_name2, args2, "1")
            assert_equal(1, @rs2["result"], "����Ӧ��2ʧ��")

            p "��������Ա����Ӧ�ã�������".encode("GBK")
            args3 = {"name" => @tc_app_name3, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            args4 = {"name" => @tc_app_name4, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_redirect_uri, "comments" => @tc_app_comments}
            @rs3 = @iam_obj.qca_app(@tc_app_name3, args3, "1", @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, @rs3["result"], "����Ӧ��3ʧ��")
            @rs4 = @iam_obj.qca_app(@tc_app_name4, args4, "1", @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, @rs4["result"], "����Ӧ��4ʧ��")

            app_name_arr = []
            flag         = false
            rs           = @iam_obj.usr_login_list_app_all(@ts_usr_name, @ts_usr_pwd)
            rs["apps"].each do |item|
                app_name_arr << item["name"]
            end
            flag = true if app_name_arr.include?(@tc_app_name1) && app_name_arr.include?(@tc_app_name2) && app_name_arr.include?(@tc_app_name3) && app_name_arr.include?(@tc_app_name4)
            assert(flag, "�û�δ��ѯ���Ѽ����Ӧ��")
        }

        operate("3���û���ѯ���󶨵�Ӧ���б�") {
            rs1 = @iam_obj.mana_active_app(@tc_app_name1, "0")
            assert_equal(1, rs1["result"], "Ӧ��1����ʧ��")
            rs2 = @iam_obj.mana_active_app(@tc_app_name2, "0")
            assert_equal(1, rs2["result"], "Ӧ��2����ʧ��")
            rs3 = @iam_obj.mana_active_app(@tc_app_name3, "0", nil, @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, rs3["result"], "Ӧ��3����ʧ��")
            rs4 = @iam_obj.mana_active_app(@tc_app_name4, "0", nil, @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, rs4["result"], "Ӧ��4����ʧ��")

            app_name_arr = []
            flag         = true
            rs           = @iam_obj.usr_login_list_app_all(@ts_usr_name, @ts_usr_pwd)
            rs["apps"].each do |item|
                app_name_arr << item["name"]
            end
            flag = false if app_name_arr.include?(@tc_app_name1) || app_name_arr.include?(@tc_app_name2) || app_name_arr.include?(@tc_app_name3) || app_name_arr.include?(@tc_app_name4)
            assert(flag, "�û���ѯ��δ�����Ӧ��")

            rs1 = @iam_obj.mana_active_app(@tc_app_name1, "1")
            assert_equal(1, rs1["result"], "Ӧ��1����ʧ��")
            rs2 = @iam_obj.mana_active_app(@tc_app_name2, "1")
            assert_equal(1, rs2["result"], "Ӧ��2����ʧ��")
            rs3 = @iam_obj.mana_active_app(@tc_app_name3, "1", nil, @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, rs3["result"], "Ӧ��3����ʧ��")
            rs4 = @iam_obj.mana_active_app(@tc_app_name4, "1", nil, @tc_manager_name, @tc_manager_pwd)
            assert_equal(1, rs4["result"], "Ӧ��4����ʧ��")

            app_name_arr = []
            flag         = false
            rs           = @iam_obj.usr_login_list_app_all(@ts_usr_name, @ts_usr_pwd)
            rs["apps"].each do |item|
                app_name_arr << item["name"]
            end
            flag = true if app_name_arr.include?(@tc_app_name1) && app_name_arr.include?(@tc_app_name2) && app_name_arr.include?(@tc_app_name3) && app_name_arr.include?(@tc_app_name4)
            assert(flag, "�û�δ��ѯ���Ѽ����Ӧ��")
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
            if @rs3["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name3)
            end
            if @rs4["result"] == 1
                @iam_obj.mana_del_app(@tc_app_name4)
            end
            if @rs["result"] == 1
                @iam_obj.del_manager(@tc_manager_name)
            end
        }
    end

}
