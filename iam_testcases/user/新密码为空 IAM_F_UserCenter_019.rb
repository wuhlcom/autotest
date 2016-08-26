#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_019", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_err_code = "11007"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、登录用户获取access_token值和uid号；") {

        }

        operate("3、修改密码，新密码为空；") {
            @rs1 = {}
            p "密码输入框中输入5个字符".encode("GBK")
            @rs1 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @ts_usr_pwd, @ts_usr_pwd, "")
            assert_equal(@tc_err_code, @rs1["err_code"], "修改密码成功")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs1["result"] == 1
                @iam_obj.usr_modify_pw_step(@ts_usr_name, "", "", @ts_usr_pwd)
            end
        }
    end

}
