#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_008", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_usr_name1 = "~!@#$%^&*()_+{}:\"|<>?-=[];'\\,./"
        @tc_usr_name2 = "中国0001"
        @tc_err_code  = "5007"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、登录用户获取access_token值和uid号；") {
            rs     = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @uid   = rs["uid"]
            @token = rs["access_token"]
        }

        operate("3、设置用户姓名为异常字符；") {
            p "输入包括特殊字符".encode("GBK")
            args = {"name" => @tc_usr_name1}
            rs   = @iam_obj.usr_modify(@uid, @token, args)
            assert_equal(@tc_err_code, rs["err_code"], "用户姓名为特殊字符时，更新资料成功")
            p "姓名中包括数字".encode("GBK")
            args = {"name" => @tc_usr_name2}
            rs   = @iam_obj.usr_modify(@uid, @token, args)
            assert_equal(@tc_err_code, rs["err_code"], "用户姓名包含数字时，更新资料成功")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
