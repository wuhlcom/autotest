#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_071", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_man_name   = "18900000000"
        @tc_nickname   = "phone_manager"
        @tc_add_passwd = "123456"
        @tc_mod_passwd = "12345678"
    end

    def process

        operate("1��SSH��¼IAMϵͳ��") {
            #����ӹ���Ա
            rs = @iam_obj.manager_del_add(@tc_man_name, @tc_add_passwd, @tc_nickname)
            assert_equal(@ts_add_rs, rs["result"], "��ӹ���Ա#{@tc_man_name}ʧ��!")
            #�޸�����
            puts "�޸�����Ϊ#{@tc_mod_passwd}".to_gbk
            rs_mod = @iam_obj.mobile_manager_modpw(@tc_man_name, @tc_mod_passwd, @tc_add_passwd, @tc_nickname)
            assert_equal(@ts_add_rs, rs_mod["result"], "�޸Ĺ���Ա#{@tc_man_name}����ʧ��!")
        }

        operate("2��ʹ���������¼��") {
            rs = @iam_obj.manager_login(@tc_man_name, @tc_mod_passwd)
            # {"result"=>1, "name"=>"18900000000", "nickname"=>"phone_manager", "uid"=>"210",
            # "role_code"=>"2", "token"=>"a53f66f4700208f3a739b0c2c284b93f"}
            assert_equal(@ts_add_rs, rs["result"], "�޸�������¼ʧ��!")
            assert_equal(@tc_man_name, rs["name"], "�޸�������¼ʧ��!")
            assert_equal(@tc_nickname, rs["nickname"], "�޸�������¼ʧ��!")
        }

        operate("3��ʹ�þ������¼��") {
            rs =  @iam_obj.manager_login(@tc_man_name, @tc_add_passwd)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_login, rs["err_msg"], "�޸������ʹ�þ����벻Ӧ�õ�¼�ɹ�!")
            assert_equal(@ts_err_login_code, rs["err_code"], "�޸������ʹ�þ����벻Ӧ�õ�¼�ɹ�!")
            assert_equal(@ts_err_login_desc, rs["err_desc"], "�޸������ʹ�þ����벻Ӧ�õ�¼�ɹ�!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
