#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_002", "level" => nil, "auto" => "n"}

    def prepare
        @tc_user_name2 = "tadashu@sohu.com"
        @tc_user_pwd   = "123123"
    end

    def process

        operate("1、ssh登录IAM服务器；") {

        }

        operate("2、登录用户；（该用户已激活）") {
            @rs = @iam_obj.register_emailusr(@tc_user_name2, @tc_user_pwd, 1)
            assert_equal(@ts_add_rs, @rs["result"], "使用邮箱注册用户失败")
            rs = @iam_obj.user_login(@tc_user_name2, @tc_user_pwd)
            assert_equal(@ts_add_rs, rs["result"], "使用已激活账户登录登录失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_delete_usr(@tc_user_name2, @tc_user_pwd)
        }
    end

}
