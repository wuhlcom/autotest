#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_014", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_err_code = "11006"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、登录用户获取access_token值和uid号；") {
            rs     = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @uid   = rs["uid"]
            @token = rs["access_token"]
        }

        operate("3、修改密码，新密码和旧密码一样；") {
            @rs = @iam_obj.mofify_user_pwd(@ts_usr_pwd, @ts_usr_pwd, @uid, @token)
            assert_equal(@tc_err_code, @rs["err_code"], "新密码和旧密码一样时，修改密码成功，或者修改失败但是返回错误码不正确")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
