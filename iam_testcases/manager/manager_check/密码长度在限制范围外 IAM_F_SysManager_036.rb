#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_036", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_man_name1 = "SysManager_035@zhilutec.com"
        @tc_passwd1   = "12345"
        @tc_man_name2 = "SysManager_0351@zhilutec.com"
        @tc_passwd2   = "abcdefghijklmnopqrstuvwxyz0001132"
        @tc_man_names =[@tc_man_name1, @tc_man_name2]
        @tc_passwds   =[@tc_passwd1, @tc_passwd2]
        @tc_nickname  = "autotest_whl"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、新增一个管理员，密码不在范围内；") {
            #如果管理员已经存在则先删除
            @tc_man_names.each_with_index do |acc, _index|
                @iam_obj.del_manager(acc)
                puts "新增管理员:‘#{acc}’，密码长度为#{@tc_passwds[_index].size}".encode("GBK")
                rs = @iam_obj.manager_add(acc, @tc_nickname, @tc_passwds[_index])
                puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
                puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
                puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
                assert_equal(@ts_err_pwformat_code, rs["err_code"], "密码长度为#{@tc_passwds[_index].size}应提示失败!")
                assert_equal(@ts_err_pwformat, rs["err_msg"], "密码长度为#{@tc_passwds[_index].size}应提示失败!")
                assert_equal(@ts_err_pwformat_desc, rs["err_desc"], "密码长度为#{@tc_passwds[_index].size}应提示失败!")
            end
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @tc_man_names.each do |acc|
                puts "delete manager:#{acc}"
                @iam_obj.del_manager(acc)
            end
        }
    end

}
