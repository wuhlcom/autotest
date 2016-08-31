#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_ApplicationCenter_009", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_app_name1        = "autotest_app1"
        @tc_app_name2        = "autotest_app2"
        @tc_app_name3        = "autotest_app3"
        @tc_app_name4        = "autotest_app4"
        @tc_app_provider1    = "application1"
        @tc_app_provider2    = "application12"
        @tc_app_provider3    = "app3"
        @tc_app_provider4    = "lication4"
        @tc_app_redirect_uri = "http://192.168.10.9"
        @tc_app_comments     = ""

        @tc_usr_names = [@tc_app_name1, @tc_app_name2, @tc_app_name3, @tc_app_name4]
        @tc_providers = [@tc_app_provider1, @tc_app_provider2, @tc_app_provider3, @tc_app_provider4]
        @tc_usr_part  = {redirect_uri: @tc_app_redirect_uri, comments: @tc_app_comments}
        @tc_usr_args  = []
        @tc_usr_names.each_with_index do |tc_usr_name, index|
            args = {name: tc_usr_name, provider: @tc_providers[index]}
            args = args.merge(@tc_usr_part)
            @tc_usr_args<<args
        end
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼�û���tokenֵ��id�ţ�") {
            rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "�û�#{@ts_phone_usr}ע��ʧ��")

            @tc_usr_args.each do |args|
                rs = @iam_obj.qca_app(args[:name], args, "1")
                assert_equal(@ts_add_rs, rs["result"], "����Ӧ��#{args[:name]}������ʧ��")
            end
        }

        operate("3�����ṩ����ȷ��ѯ��") {
            rs3 = @iam_obj.usr_login_list_app_bytype(@ts_phone_usr, @ts_usr_pw, @tc_app_provider3, false, "provider")
            assert_equal(@tc_app_provider3, rs3["apps"][0]["provider"], "��ѯӦ��3ʧ��")
            rs4 = @iam_obj.usr_login_list_app_bytype(@ts_phone_usr, @ts_usr_pw, @tc_app_provider4, false, "provider")
            assert_equal(@tc_app_provider4, rs4["apps"][0]["provider"], "��ѯӦ��4ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
            @tc_usr_args.each do |args|
                @iam_obj.mana_del_app(args[:name])
            end
        }
    end

}
