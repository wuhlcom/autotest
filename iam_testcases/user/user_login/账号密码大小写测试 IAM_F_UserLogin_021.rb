#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserLogin_001", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_usr_name    = "liluping@zhilutec.com"
        @tc_usr_pwd     = "123456"
        @tc_usr_pwd_new = "liluping"
        @tc_err_code    = "10001"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            @rs = @iam_obj.user_login(@tc_usr_name, @tc_usr_pwd)
            @md = @iam_obj.mofify_user_pwd(@tc_usr_pwd, @tc_usr_pwd_new, @rs["uid"], @rs["access_token"])
            assert_equal(1, @md["result"], "修改密码为字母类型时失败")
        }

        operate("2、用户登录，账号、密码输入含有大小写字母；") {
            rs = @iam_obj.user_login(@tc_usr_name.upcase, @tc_usr_pwd_new.upcase)
            assert_equal(@tc_err_code, rs["err_code"], "账号密码含有大小写字母登录时登录成功或者是登录失败但是返回的错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @md["result"] == 1
                rs = @iam_obj.user_login(@tc_usr_name, @tc_usr_pwd_new)
                @iam_obj.mofify_user_pwd(@tc_usr_pwd_new, @tc_usr_pwd, rs["uid"], rs["access_token"])
            end
        }
    end

}
