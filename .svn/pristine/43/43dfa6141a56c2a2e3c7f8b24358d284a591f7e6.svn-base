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

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、管理员登录，账号密码特殊字符；") {
            rs = @iam_obj.manager_login(@ts_login_url, @tc_admin_log_name, @tc_admin_log_pw)
            # {"err_code"=>"10001", "err_msg"=>"\u5E10\u53F7\u6216\u5BC6\u7801\u9519\u8BEF", "err_desc"=>"E_USER_PWD_ERROR"}
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_login_code, rs["err_code"], "账号和密码都为空返回错误码不正确!")
            assert_equal(@ts_err_login, rs["err_msg"], "账号和密码都为空返回消息不正确!")
            assert_equal(@ts_err_login_desc, rs["err_desc"], "账号和密码都为空返回描述不正确!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
