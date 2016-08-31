#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_036", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_num    = "15814035400"
        @tc_phone_pw     = "123123"
        @tc_phone_pw_new = "123456"
        @tc_usr_regargs  = {type: "account", cond: @tc_phone_num}
        @tc_wait_time    = 125 #有延迟，增加5s
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_num, @tc_phone_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_num}注册失败")
        }

        operate("2、获取手机验证码；") {
            re = @iam_obj.request_mobile_code(@tc_phone_num) #请求验证码
            p @code = re["code"]
            refute(@code.nil?, "获取验证码失败")
        }

        operate("3、2分钟以后进行密码找回；") {
            sleep @tc_wait_time
            tip = "2分钟以后进行密码找回"
            rs  = @iam_obj.usr_modpw_mobile_bycode(@tc_phone_num, @tc_phone_pw_new, @code)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_pcoderr_code, rs["err_code"], "#{tip}返回code错误!")
            assert_equal(@ts_err_pcoderr_msg, rs["err_msg"], "#{tip}返回msg错误")
            assert_equal(@ts_err_pcoderr_desc, rs["err_desc"], "#{tip}返回desc错误!")

        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_delete_usr(@tc_phone_num, @tc_phone_pw)
            @iam_obj.usr_delete_usr(@tc_phone_num, @tc_phone_pw_new)
        }
    end

}
