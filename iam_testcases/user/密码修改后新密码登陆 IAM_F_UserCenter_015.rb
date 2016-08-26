#
# description:
# author:liiluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_015", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_new_pwd = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、登录用户获取access_token值和uid号；") {
            rs     = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @uid   = rs["uid"]
            @token = rs["access_token"]
        }

        operate("3、修改密码；") {
            @rs = @iam_obj.mofify_user_pwd(@ts_usr_pwd, @tc_new_pwd, @uid, @token)
            assert_equal(1, @rs["result"], "修改密码失败")
        }

        operate("4、使用新密码登录；") {
            rs = @iam_obj.user_login(@ts_usr_name, @tc_new_pwd)
            assert_equal(1, rs["result"], "使用新密码登录失败")
            @new_uid   = rs["uid"]
            @new_token = rs["access_token"]
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs["result"] == 1
                @iam_obj.mofify_user_pwd(@tc_new_pwd, @ts_usr_pwd, @new_uid, @new_token)
            end
        }
    end

}
