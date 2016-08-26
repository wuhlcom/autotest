#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserLogin_001", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_err_code = "10001"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、用户登录，密码输入为空；") {
            rs = @iam_obj.user_login(@ts_usr_name, "")
            assert_equal(@tc_err_code, rs["err_code"], "密码为空时登录成功或者是登录失败但是返回的错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
