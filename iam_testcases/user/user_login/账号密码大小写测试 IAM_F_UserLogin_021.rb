#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {

    attr = {"id" => "IAM_F_UserLogin_021", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_usr_pwd_new = "liluping"
    end

    def process


        operate("1、ssh登录IAM服务器；") {
            @rs= @iam_obj.email_usr_reg(@ts_email_usr, @ts_email_pw, @ts_email_regargs)
            assert_equal(@ts_add_rs, @rs["result"], "用户#{@ts_phone_usr}注册失败")


            p @md = @iam_obj.usr_modify_pw_step(@ts_email_usr, @ts_email_pw, @ts_email_pw, @tc_usr_pwd_new)
            assert_equal(@ts_add_rs, @md["result"], "修改密码为#{@tc_usr_pwd_new}时失败")
        }

        operate("2、用户登录，账号、密码输入含有大小写字母；") {
            rs  = @iam_obj.user_login(@ts_phone_usr.upcase, @tc_usr_pwd_new)
            tip = "用户登录，账号输入含有大小写字母"
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_login_code, rs["err_code"], "#{tip}返回code错误!")
            assert_equal(@ts_err_login, rs["err_msg"], "#{tip}返回msg错误")
            assert_equal(@ts_err_login_desc, rs["err_desc"], "#{tip}返回desc错误!")

            rs  = @iam_obj.user_login(@ts_phone_usr, @tc_usr_pwd_new.upcase)
            tip = "用户登录，密码输入含有大小写字母"
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_login_code, rs["err_code"], "#{tip}返回code错误!")
            assert_equal(@ts_err_login, rs["err_msg"], "#{tip}返回msg错误")
            assert_equal(@ts_err_login_desc, rs["err_desc"], "#{tip}返回desc错误!")
        }
    end


    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_delete_usr(@ts_email_usr, @ts_email_pw)
            @iam_obj.usr_delete_usr(@ts_email_usr, @tc_usr_pwd_new)
        }
    end

}
