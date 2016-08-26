#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_013", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_new_pwd  = "123456"
        @tc_err_code = "11005"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录用户access_token值和uid号；") {
            rs     = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @uid   = rs["uid"]
            @token = rs["access_token"]
        }

        operate("3、修改密码，旧密码输入有误") {
            @tc_old_pwd = @ts_usr_pwd + "err"
            @rs         = @iam_obj.mofify_user_pwd(@tc_old_pwd, @tc_new_pwd, @uid, @token)
            assert_equal(@tc_err_code, @rs["err_code"], "旧密码输入有误时，修改密码成功，或者修改失败但是返回错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs["result"] == 1
                rs = @iam_obj.user_login(@ts_usr_name, @tc_new_pwd)
                @iam_obj.mofify_user_pwd(@tc_new_pwd, @ts_usr_pwd, rs["uid"], rs["access_token"])
            end
        }
    end

}
