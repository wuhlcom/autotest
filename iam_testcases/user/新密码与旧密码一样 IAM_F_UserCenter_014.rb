#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_014", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_usr   = "15857031512"
        @tc_usr_pw      = "123456"
        @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")
        }

        operate("2、登录用户获取access_token值和uid号；") {
        }

        operate("3、修改密码，新密码和旧密码一样；") {
            tip = "修改密码，新密码和旧密码一样"
            rs  = @iam_obj.usr_modify_pw_step(@tc_phone_usr, @tc_usr_pw, @tc_usr_pw, @tc_usr_pw)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_pwsame_code, rs["err_code"], "#{tip}返回code错误!")
            assert_equal(@ts_err_pwsame_msg, rs["err_msg"], "#{tip}返回msg错误")
            assert_equal(@ts_err_pwsame_desc, rs["err_desc"], "#{tip}返回desc错误!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
        }
    end

}
