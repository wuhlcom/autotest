#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_006", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_usr_name1 = "王王王王王王王王王王王王王王王王a"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、登录用户获取access_token值和uid号；") {
            rs     = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @uid   = rs["uid"]
            @token = rs["access_token"]
        }

        operate("3、设置用户姓名超过支持长度；") {
            p "姓名输入17个字符".encode("GBK")
            args = {"name" => @tc_usr_name1}
            rs   = @iam_obj.usr_modify(@uid, @token, args)
            assert_equal(1, rs["result"], "修改用户姓名为17个字符时失败！")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
