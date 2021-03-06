#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_033", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_phone_num = "15814037401"
        @tc_phone_pw  = "123123"
        @tc_err_code  = "11002"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取手机验证码；") {
            rs    = @iam_obj.request_mobile_code(@tc_phone_num)
            @code = rs["code"]
            p "手机获取正确的验证码为：#{@code}".encode("GBK")
        }

        operate("3、修改密码，验证码输入错误；") {
            err_code = (@code.to_i+1).to_s
            p "修改之后的验证码为：#{err_code}".encode("GBK")
            rs = @iam_obj.usr_modpw_mobile_bycode(@tc_phone_num, @tc_phone_pw, err_code)
            assert_equal(@tc_err_code, rs["err_code"], "手机使用错误的验证码找回密码成功，或者找回失败但是返回的错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
