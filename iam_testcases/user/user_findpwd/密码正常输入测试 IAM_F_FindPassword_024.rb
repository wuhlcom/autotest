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
        @tc_phone_pw         = [@tc_phone_pw1, @tc_phone_pw2, @tc_phone_pw3]
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            p "注册新用户".encode("GBK")
            @rs = @iam_obj.register_phoneusr(@tc_phone_num, @tc_phone_pw_default)
            assert_equal(1, @rs["result"], "手机注册用户失败")
        }

        operate("2、获取手机验证码；") {

        }

        operate("3、修改密码；") {
            @tc_phone_pw.each do |pwd|
                p "修改密码为：#{pwd}".to_gbk
                rs1 = @iam_obj.usr_modpw_mobile(@tc_phone_num, pwd)
                if rs1["result"] == 1
                    flag                 = true
                    @tc_phone_pw_default = pwd
                else
                    flag = false
                end
                assert(flag, "修改密码#{pwd}失败")
            end
        }
    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_delete_usr(@tc_phone_num, @tc_phone_pw_default)
        }
    end

}
