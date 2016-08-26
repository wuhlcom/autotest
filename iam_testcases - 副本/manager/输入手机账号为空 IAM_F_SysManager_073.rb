#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_073", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_man_name=""
    end

    def process

        operate("1、SSH登录IAM系统；") {
        }

        operate("2、手机号为空、获取手机验证码；") {
            rs = @iam_obj.request_mobile_code(@tc_man_name)
           puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
           puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
           puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
           assert_equal(@ts_err_phonull_msg, rs["err_msg"], "修改密码后使用旧密码不应该登录成功!")
           assert_equal(@ts_err_phonull_errcode, rs["err_code"], "修改密码后使用旧密码不应该登录成功!")
           assert_equal(@ts_err_phonull_code_desc, rs["err_desc"], "修改密码后使用旧密码不应该登录成功!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
