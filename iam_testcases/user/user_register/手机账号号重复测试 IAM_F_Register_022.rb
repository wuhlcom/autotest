#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_022", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_phone_num = "15814037406"
        @tc_phone_pwd = "123123"
        @tc_err_code  = "5006"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、输入手机号码获取验证码；") {

        }

        operate("3、使用该手机号码进行注册；") {
            @rs = @iam_obj.register_phoneusr(@tc_phone_num, @tc_phone_pwd)
            assert_equal(1, @rs["result"], "使用手机号注册用户失败")
        }

        operate("4、再次使用步骤3的手机号码进程注册；") {
            rs = @iam_obj.register_phoneusr(@tc_phone_num, @tc_phone_pwd)
            assert_equal(@tc_err_code, rs["err_code"], "使用相同手机号注册用户成功或者注册失败但错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_num, @tc_phone_pwd)
            end
        }
    end

}
