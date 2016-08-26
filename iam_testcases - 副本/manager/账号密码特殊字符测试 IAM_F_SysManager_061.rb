#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_061", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_admin_log_name = "!zhilu&&@suho.com"
        @tc_admin_log_pw   = "p_%^:?>23"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2������Ա��¼���˺����������ַ���") {
            rs = @iam_obj.manager_login(@tc_admin_log_name, @tc_admin_log_pw)
            # {"err_code"=>"10001", "err_msg"=>"\u5E10\u53F7\u6216\u5BC6\u7801\u9519\u8BEF", "err_desc"=>"E_USER_PWD_ERROR"}
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_login_code, rs["err_code"], "�˺ź����붼Ϊ�շ��ش����벻��ȷ!")
            assert_equal(@ts_err_login, rs["err_msg"], "�˺ź����붼Ϊ�շ�����Ϣ����ȷ!")
            assert_equal(@ts_err_login_desc, rs["err_desc"], "�˺ź����붼Ϊ�շ�����������ȷ!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
