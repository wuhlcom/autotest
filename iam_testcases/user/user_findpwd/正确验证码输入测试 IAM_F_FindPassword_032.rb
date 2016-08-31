#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_032", "level" => "P1", "auto" => "n"}

    def prepare
       
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            @rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
            assert_equal(@ts_add_rs, @rs["result"], "用户#{@ts_phone_usr}注册失败")
        }

        operate("2、获取手机验证码；") {
        }

        operate("3、修改密码；") {

        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
            end
        }
    end

}
