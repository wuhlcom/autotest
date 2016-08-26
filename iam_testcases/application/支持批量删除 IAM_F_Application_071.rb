#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_071", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_app_usr1     = "autotest_new1"
        @tc_app_usr2     = "autotest_new2"
        @tc_app_provider = "autotest"
        @tc_app_red_uri  = "http://192.168.10.9"
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

        operate("3����ȡӦ���б�ȡ��û�а�Ӧ�ú��豸��Ӧ��ID�ţ�") {
            #�´�������Ӧ�ã�������Ӧ�þ�����û�а��豸��Ӧ��
            p "����һ����Ӧ��".encode("GBK")
            args = {"name"=>@tc_app_usr1, "provider"=>@tc_app_provider, "redirect_uri"=>@tc_app_red_uri, "comments"=>""}
            rs   = @iam_obj.create_apply(@admin_id, @admin_token, args)
            assert_equal(1, rs["result"], "����Ӧ��ʧ�ܣ�")

            p "�ٴδ���һ����Ӧ��".encode("GBK")
            args = {"name"=>@tc_app_usr2, "provider"=>@tc_app_provider, "redirect_uri"=>@tc_app_red_uri, "comments"=>""}
            rs   = @iam_obj.create_apply(@admin_id, @admin_token, args)
            assert_equal(1, rs["result"], "����Ӧ��ʧ�ܣ�")

        }

        operate("4������ɾ��Ӧ�ã�") {
            appname = [@tc_app_usr1, @tc_app_usr2]
            rs = @iam_obj.del_apply(appname, @admin_token, @admin_id)
            assert_equal(1, rs["result"], "����ɾ��Ӧ��ʧ�ܣ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
