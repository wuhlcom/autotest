#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_022", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_man_name1 = ""
        @tc_nickname1     = "13760281577"
        @tc_passwd        = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、手机号为空，新增一个管理员；") {
            p rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            # {"err_code":"5003","err_msg":"\u5e10\u53f7\u683c\u5f0f\u9519\u8bef","err_desc":"E_ACCOUNT_FORMAT_ERROR"}
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_accformat_code, rs["err_code"], "添加手机账户为空应提示失败!")
            assert_equal(@ts_err_accformat, rs["err_msg"], "添加手机账户为空应提示失败!")
            assert_equal(@ts_err_accformat_desc, rs["err_desc"], "添加手机账户为空应提示失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
