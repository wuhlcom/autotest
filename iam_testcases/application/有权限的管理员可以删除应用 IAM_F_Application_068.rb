#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_068", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_app_usr1 = "autotest_app1"
        @tc_app_usr2 = "autotest_app2"
        @tc_app_provider  = "autotest"
        @tc_app_red_uri   = "http://192.168.10.9"
        @tc_app_comments  = ""
        @tc_err_code      = "22013"

        @tc_app_names     = [@tc_app_usr1, @tc_app_usr2]
        @tc_account_arr   = [@ts_app_super_manage, @ts_app_system_manage]
        @tc_usr_part      = {provider: @tc_app_provider, redirect_uri: @tc_app_red_uri, comments: @tc_app_comments}
        @tc_usr_args      = []
        @tc_app_names.each do |tc_usr_name|
            args = {name: tc_usr_name}
            args = args.merge(@tc_usr_part)
            @tc_usr_args<<args
        end
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ֪·����Աtokenֵ��") {
            p "����һ����������Ա�˻�".encode("GBK")
            rs = @iam_obj.manager_del_add(@ts_app_super_manage, @ts_app_manage_pwd, @ts_app_super_manage_nickname)
            assert_equal(@ts_add_rs, rs["result"], "������������Ա#{@ts_app_super_manage}ʧ�ܣ�")
            p "����һ��ϵͳ����Ա�˻�".encode("GBK")
            rs = @iam_obj.manager_del_add(@ts_app_system_manage, @ts_app_manage_pwd, @ts_app_system_manage_nickname, "3")
            assert_equal(@ts_add_rs, rs["result"], "����ϵͳ����Ա#{@ts_app_system_manage}ʧ�ܣ�")
        }

        operate("3����ȡҪɾ��Ӧ��ID�ţ�") {
            p "����������Ӧ��".encode("GBK")
            @tc_usr_args.each do |args|
                rs = @iam_obj.qca_app(args[:name], args, "0", @ts_app_super_manage, @ts_app_manage_pwd)
                assert_equal(@ts_add_rs, rs["result"], "����Ա����Ӧ��#{args[:name]}ʧ��")
            end
        }

        operate("4��֪·����Աɾ����Ӧ�ã�") {
            rs = @iam_obj.mana_del_app(@tc_app_usr1, nil, @ts_app_super_manage, @ts_app_manage_pwd)
            assert_equal(1, rs["result"], "��������Աɾ��Ӧ��ʧ�ܣ�")
        }

        operate("5����¼һ��ϵͳ����Ա����ȡ��ϵͳ����Ա��tokenֵ��") {

        }

        operate("6��ϵͳ����Աɾ��һ��Ӧ�ã�") {
            tip  = "ϵͳ����Աɾ��һ��Ӧ��"
            rs = @iam_obj.mana_del_app(@tc_app_usr2, nil, @ts_app_system_manage, @ts_app_manage_pwd)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_delapp_code, rs["err_code"], "#{tip}����code����!")
            assert_equal(@ts_err_delapp_msg, rs["err_msg"], "#{tip}����msg����")
            assert_equal(@ts_err_delapp_desc, rs["err_desc"], "#{tip}����desc����!")

        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.mana_del_app(@tc_app_usr1)
            @iam_obj.mana_del_app(@tc_app_usr2)

            @iam_obj.del_manager(@ts_app_super_manage)
            @iam_obj.del_manager(@ts_app_system_manage)
        }
    end

}
