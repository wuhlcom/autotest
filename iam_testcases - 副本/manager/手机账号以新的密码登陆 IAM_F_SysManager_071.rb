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

        operate("1、SSH登录IAM系统；") {
            #先添加管理员
            rs = @iam_obj.manager_del_add(@tc_man_name, @tc_add_passwd, @tc_nickname)
            assert_equal(@ts_add_rs, rs["result"], "添加管理员#{@tc_man_name}失败!")
            #修改密码
            puts "修改密码为#{@tc_mod_passwd}".to_gbk
            rs_mod = @iam_obj.mobile_manager_modpw(@tc_man_name, @tc_mod_passwd, @tc_add_passwd, @tc_nickname)
            assert_equal(@ts_add_rs, rs_mod["result"], "修改管理员#{@tc_man_name}密码失败!")
        }

        operate("2、使用新密码登录；") {
            rs = @iam_obj.manager_login(@tc_man_name, @tc_mod_passwd)
            # {"result"=>1, "name"=>"18900000000", "nickname"=>"phone_manager", "uid"=>"210",
            # "role_code"=>"2", "token"=>"a53f66f4700208f3a739b0c2c284b93f"}
            assert_equal(@ts_add_rs, rs["result"], "修改密码后登录失败!")
            assert_equal(@tc_man_name, rs["name"], "修改密码后登录失败!")
            assert_equal(@tc_nickname, rs["nickname"], "修改密码后登录失败!")
        }

        operate("3、使用旧密码登录；") {
            rs =  @iam_obj.manager_login(@tc_man_name, @tc_add_passwd)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_login, rs["err_msg"], "修改密码后使用旧密码不应该登录成功!")
            assert_equal(@ts_err_login_code, rs["err_code"], "修改密码后使用旧密码不应该登录成功!")
            assert_equal(@ts_err_login_desc, rs["err_desc"], "修改密码后使用旧密码不应该登录成功!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
