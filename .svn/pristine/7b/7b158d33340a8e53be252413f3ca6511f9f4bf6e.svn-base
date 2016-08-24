#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_072", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_man_name1 = "1361234123"
        @tc_man_name2 = "136123412345"
        @tc_man_name3 = "1361234u234"
        @tc_man_names =[@tc_man_name1, @tc_man_name2, @tc_man_name3]
    end

    def process

        operate("1、SSH登录IAM系统；") {

        }

        operate("2、错误手机号，获取手机验证码；") {
            @tc_man_names.each do |phone|
                puts "获取手机账号#{phone}的验证码".to_gbk
                rs = @iam_obj.request_mobile_code(phone)
                puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
                puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
                puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
                assert_equal(@ts_err_pho_code_msg, rs["err_msg"], "修改密码后使用旧密码不应该登录成功!")
                assert_equal(@ts_err_pho_errcode, rs["err_code"], "修改密码后使用旧密码不应该登录成功!")
                assert_equal(@ts_err_pho_code_desc, rs["err_desc"], "修改密码后使用旧密码不应该登录成功!")
            end
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
