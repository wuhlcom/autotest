#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_050", "level" => "P1", "auto" => "n"}

    def prepare

    end

    def process

        operate("1、ssh登录到IAM服务器；") {
        }

        operate("2、登录知路管理员；") {
            rs = @iam_obj.manager_login(@ts_admin_log_name,@ts_admin_log_pw)
            # {"result":1,"name":"admin@zhilutec.com","nickname":"\u77e5\u8def\u7ba1\u7406\u5458",
            # "uid":"1","role_code":"1","token":"e4f0326fa441186b18dcd66dc4509466"}
            puts "RESULT result:#{rs['result']}".encode("GBK")
            assert_equal(@ts_admin_log_rs, rs["result"], "管理员返回信息错误!")

            puts "RESULT name:#{rs['name']}".encode("GBK")
            assert_equal(@ts_admin_log_name, rs["name"], "管理员返回name信息错误!")

            puts "RESULT nickname:#{rs['nickname']}".encode("GBK")
            assert_equal(@ts_admin_log_nickname, rs["nickname"], "管理员返回nickname信息错误!")

            puts "RESULT uid:#{rs['uid']}".encode("GBK")
            assert_equal(@ts_admin_log_uid, rs["uid"], "管理员返回信息错误!")

            puts "RESULT role_code:#{rs['role_code']}".encode("GBK")
            assert_equal(@ts_admin_rcode, rs["role_code"], "管理员返回role_code信息错误!")

            puts "RESULT token:#{rs['token']}".encode("GBK")
            refute_nil(rs["token"], "token!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
