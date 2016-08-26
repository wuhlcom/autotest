#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_016", "level" => nil, "auto" => "n"}

    def prepare
        @tc_usr_phone = "15814037401"
        @tc_pwd       = "123123"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取验证码；") {

        }

        operate("3、手机注册用户；") {
            @rs = @iam_obj.register_phoneusr(@tc_usr_phone, @tc_pwd)
            assert_equal(1, @rs["result"], "手机注册用户失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_usr(@tc_usr_phone, @tc_pwd)
            end
        }
    end

}
