#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_068", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_superapp_usr  = "autotest_super"
        @tc_systemapp_usr = "autotest_system"
        @tc_app_provider  = "autotest"
        @tc_app_red_uri   = "http://192.168.10.9"
        @tc_err_code      = "22013"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ֪·����Աtokenֵ��") {
            p "����һ����������Ա�˻�".encode("GBK")
            rs = @iam_obj.manager_del_add(@ts_app_super_manage, @ts_app_manage_pwd, @ts_app_super_manage_nickname)
            assert_equal(1, rs["result"], "������������Աʧ�ܣ�")
            p "����һ��ϵͳ����Ա�˻�".encode("GBK")
            rs = @iam_obj.manager_del_add(@ts_app_system_manage, @ts_app_manage_pwd, @ts_app_system_manage_nickname, "3")
            assert_equal(1, rs["result"], "����ϵͳ����Աʧ�ܣ�")
        }

        operate("3����ȡҪɾ��Ӧ��ID�ţ�") {
            p "����һ����Ӧ��".encode("GBK")
            args = {"name" => @tc_superapp_usr, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_red_uri, "comments" => ""}
            rs   = @iam_obj.mana_create_app(args, "0", @ts_app_super_manage, @ts_app_manage_pwd)
            assert_equal(1, rs["result"], "��������Ա����Ӧ��ʧ�ܣ�")

            args = {"name" => @tc_systemapp_usr, "provider" => @tc_app_provider, "redirect_uri" => @tc_app_red_uri, "comments" => ""}
            rs   = @iam_obj.mana_create_app(args, "0", @ts_app_system_manage, @ts_app_manage_pwd)
            assert_equal(1, rs["result"], "ϵͳ����Ա����Ӧ��ʧ�ܣ�")
        }

        operate("4��֪·����Աɾ����Ӧ�ã�") {
            rs = @iam_obj.mana_del_app(@tc_superapp_usr, nil, @ts_app_super_manage, @ts_app_manage_pwd)
            assert_equal(1, rs["result"], "��������Աɾ��Ӧ��ʧ�ܣ�")
        }

        operate("5����¼һ��ϵͳ����Ա����ȡ��ϵͳ����Ա��tokenֵ��") {

        }

        operate("6��ϵͳ����Աɾ��һ��Ӧ�ã�") {
            rs = @iam_obj.mana_del_app(@tc_systemapp_usr, nil, @ts_app_system_manage, @ts_app_manage_pwd)
            assert_equal(@tc_err_code, rs["err_code"], "ϵͳ����Աɾ��Ӧ��ʧ�ܺ󷵻صĴ����벻��ȷ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.mana_del_app(@tc_superapp_usr)
            @iam_obj.mana_del_app(@tc_systemapp_usr)

            @iam_obj.del_manager(@ts_app_super_manage)
            @iam_obj.del_manager(@ts_app_system_manage)
        }
    end

}
