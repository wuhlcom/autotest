#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_037", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_man_name1 = "SysManager_037@zhilutec.com"
        @tc_passwd1   = ""
        @tc_nickname  = "autotest_whl"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、新增一个管理员，密码为空；") {
            @iam_obj.del_manager(@tc_man_name1)
            puts "新增管理员:‘#{@tc_man_name1}’，密码长度为#{@tc_passwd1}".encode("GBK")
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname, @tc_passwd1)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_pwformat_code, rs["err_code"], "密码为空应提示失败!")
            assert_equal(@ts_err_pwformat, rs["err_msg"], "密码为空应提示失败!")
            assert_equal(@ts_err_pwformat_desc, rs["err_desc"], "密码为空应提示失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.del_manager(@tc_man_name1)
        }
    end

}
