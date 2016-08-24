#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_075", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_man_name  = "13525468967"
        @tc_add_passwd= "123456"
        @tc_mod_passwd= "12345678"
        @tc_nickname  = "hahawangle"
        @tc_code      = ""
    end

    def process

        operate("1、SSH登录IAM系统；") {
        }

        operate("2、添加手机账号管理员；") {
            #先添加管理员
            rs = @iam_obj.manager_del_add(@tc_man_name, @tc_add_passwd, @tc_nickname)
            assert_equal(@ts_add_rs, rs["result"], "添加管理员#{@tc_man_name}失败!")
        }

        operate("3、输入新密码、验证码为空；") {
            rs = @iam_obj.phone_manager_modpw(@tc_man_name, @tc_mod_passwd, @tc_code)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_pcodnul_msg, rs["err_msg"], "验证码为空返回错误消息不正确!")
            assert_equal(@ts_err_pcodnul_code, rs["err_code"], "验证码为空返回错误code不正确!")
            assert_equal(@ts_err_pcodnul_desc, rs["err_desc"], "验证码为空返回错误desc不正确!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
