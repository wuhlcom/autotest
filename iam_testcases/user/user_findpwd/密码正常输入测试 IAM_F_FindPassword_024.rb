#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_024", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_num        = "15814037401" #这里要使用正确的已在网页上注册的手机号
        @tc_phone_pw_default = "123456"
        @tc_phone_pw1        = "123123"
        @tc_phone_pw2        = "aa12347890aa12347890aa1234789012"
        @tc_phone_pw3        = "123__22Aa"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取手机验证码；") {

        }

        operate("3、修改密码；") {
            rs1 = @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw1)
            assert_equal(1, rs1["result"], "修改密码1失败")
            rs2 = @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw2)
            assert_equal(1, rs2["result"], "修改密码2失败")
            rs3 = @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw3)
            assert_equal(1, rs3["result"], "修改密码3失败")
        }
    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_modpw_mobile(@tc_phone_num, @tc_phone_pw_default)
        }
    end

}
