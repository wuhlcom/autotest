#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_076", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_man_name  = "13500001111"
        @tc_add_passwd= "123456"
        @tc_mod_passwd= "12345678"
        @tc_nickname  = "hahawangle"
        @tc_code      = "0000"
    end

    def process

        operate("1��SSH��¼IAMϵͳ��") {
        }

        operate("2����ȡ�ֻ���֤�룻") {
            #����ӹ���Ա
            rs = @iam_obj.manager_del_add(@tc_man_name, @tc_add_passwd, @tc_nickname)
            assert_equal(@ts_add_rs, rs["result"], "��ӹ���Ա#{@tc_man_name}ʧ��!")
        }

        operate("3�����������롢����������֤�룻") {
            rs = @iam_obj.phone_manager_modpw(@tc_man_name, @tc_mod_passwd, @tc_code)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_pcodnul_msg, rs["err_msg"], "����������֤�뷵�ش�����Ϣ����ȷ!")
            assert_equal(@ts_err_pcodnul_code, rs["err_code"], "����������֤�뷵�ش���code����ȷ!")
            assert_equal(@ts_err_pcodnul_desc, rs["err_desc"], "����������֤�뷵�ش���desc����ȷ!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
