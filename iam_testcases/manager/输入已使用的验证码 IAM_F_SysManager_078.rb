#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_078", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_man_name    = "13566600000"
        @tc_add_passwd  = "123456"
        @tc_mod_passwd1 = "12345678"
        @tc_mod_passwd2 = "12345678"
        @tc_nickname    = "hahawangle"

    end

    def process

        operate("1、SSH登录IAM系统；") {
        }

        operate("2、获取手机验证码；") {
            #先添加管理员
            rs = @iam_obj.manager_del_add(@tc_man_name, @tc_add_passwd, @tc_nickname)
            assert_equal(@ts_add_rs, rs["result"], "添加管理员#{@tc_man_name}失败!")
        }

        operate("3、输入新密码、验证码已使用；") {
            rs_recode = @iam_obj.request_mobile_code(@tc_man_name)
            puts "等待验证码#{rs_recode["code"]}超时,sleep #{@tc_timeout_time} seconds...".to_gbk
            sleep @tc_timeout_time
            rs_getcode= @iam_obj.get_mobile_code(@tc_man_name)
            puts "等待验证码#{@tc_timeout_time} seconds超时后，获取得验证码为#{rs_getcode["code"]}".to_gbk
            p rs = @iam_obj.phone_manager_modpw(@tc_man_name, @tc_mod_passwd, rs_getcode["code"])
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_pcoderr_msg, rs["err_msg"], "输入错误的验证码返回错误消息不正确!")
            assert_equal(@ts_err_pcoderr_code, rs["err_code"], "输入错误的验证码返回错误code不正确!")
            assert_equal(@ts_err_pcoderr_desc, rs["err_desc"], "输入错误的验证码返回错误desc不正确!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
