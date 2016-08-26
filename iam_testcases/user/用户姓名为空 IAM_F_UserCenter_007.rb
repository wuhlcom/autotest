#
# description: 接口有问题，姓名为空时，可以保存成功，手动、页面、脚本现象一致
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_007", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_err_code = ""
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、登录用户获取access_token值和uid号；") {
            rs     = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @uid   = rs["uid"]
            @token = rs["access_token"]
        }

        operate("3、设置用户姓名为空；") {
            args = {"name" => ""}
            rs   = @iam_obj.usr_modify(@uid, @token, args)
            assert_equal(@tc_err_code, rs["err_code"], "用户姓名为空时，更新资料成功")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
