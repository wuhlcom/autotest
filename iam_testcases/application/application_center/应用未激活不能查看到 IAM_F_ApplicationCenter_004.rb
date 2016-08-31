#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_ApplicationCenter_004", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_manager_name     = "super@qq.com"
        @tc_manager_nickname = "SUPER_MAN"
        @tc_manager_pwd      = "123456"
        @tc_phone_usr        = "15814031512"
        @tc_usr_pw           = "123456"
        @tc_usr_regargs      = {type: "account", cond: @tc_phone_usr}

        @tc_app_name1        = "autotest_app1"
        @tc_app_name2        = "autotest_app2"
        @tc_app_name3        = "autotest_app3"
        @tc_app_name4        = "autotest_app4"
        @tc_app_provider     = "zhilutest"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""
        @tc_zhilu_manage     = [@tc_app_name1, @tc_app_name2]
        @tc_super_manage     = [@tc_app_name3, @tc_app_name4]
        @tc_usr_part         = {provider: @tc_app_provider, redirect_uri: @tc_app_redirect_uri, comments: @tc_app_comments}
        @tc_zhilu_args       = []
        @tc_super_args       = []
        @tc_zhilu_manage.each do |tc_usr_name|
            args = {name: tc_usr_name}
            args = args.merge(@tc_usr_part)
            @tc_zhilu_args<<args
        end
        @tc_super_manage.each do |tc_usr_name|
            args = {name: tc_usr_name}
            args = args.merge(@tc_usr_part)
            @tc_super_args<<args
        end
        @tc_manage_name = @tc_zhilu_manage + @tc_super_manage
    end

    def process

        operate("1��ssh��¼IAM��������") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")
        }

        operate("2��֪·����Ա�½�һ��Ӧ�ã�") {
            @rs = @iam_obj.manager_add(@tc_manager_name, @tc_manager_nickname, @tc_manager_pwd)
            assert_equal(1, @rs["result"], "������������Աʧ��")

            p "֪·��������Ա����Ӧ�ã�������".encode("GBK")
            @tc_zhilu_args.each do |args|
                rs = @iam_obj.qca_app(args[:name], args, "0")
                assert_equal(@ts_add_rs, rs["result"], "֪·����Ա����Ӧ��#{args[:name]}ʧ��")
            end

            p "��������Ա����Ӧ�ã�������".encode("GBK")
            @tc_super_args.each do |args|
                rs = @iam_obj.qca_app(args[:name], args, "0", @tc_manager_name, @tc_manager_pwd)
                assert_equal(@ts_add_rs, rs["result"], "��������Ա����Ӧ��#{args[:name]}ʧ��")
            end
        }

        operate("3����ȡ��¼�û���tokenֵ��id�ţ�") {
        }

        operate("4���û���ѯ���󶨵�Ӧ���б�") {
            app_name_arr = []
            flag         = true
            rs           = @iam_obj.usr_login_list_app_all(@tc_phone_usr, @tc_usr_pw)
            rs["apps"].each do |item|
                app_name_arr << item["name"]
            end
            flag = false if app_name_arr.include?(@tc_app_name1) || app_name_arr.include?(@tc_app_name2) || app_name_arr.include?(@tc_app_name3) || app_name_arr.include?(@tc_app_name4)
            assert(flag, "�û���ѯ��δ�����Ӧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            rs_login = @iam_obj.manager_login(@ts_admin_usr, @ts_admin_pw)
            token    = rs_login["token"]
            uid      = rs_login["uid"]
            @tc_manage_name.each do |name|
                @iam_obj.del_apply(name, token, uid)
            end
            @iam_obj.del_manager(@tc_manager_name)
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
        }
    end

}
