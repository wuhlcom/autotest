#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_016", "level" => "P4", "auto" => "n"}

    def prepare
        str = "ＺＨＩＬＵ".encode("utf-8")
        @tc_man_name1 = "#{str}@zhilutec.com"
        @tc_nickname = "autotest_whl"
        @tc_passwd   = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、邮箱账号异常输入时，新增管理员：") {
            #如果管理员已经存在则先删除
            # @iam_obj.del_manager(@tc_man_name1)
            puts "添加超级管理员账户为:#{@tc_man_name1}".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname, @tc_passwd)
            # {"err_code":"5003","err_msg":"\u5e10\u53f7\u683c\u5f0f\u9519\u8bef","err_desc":"E_ACCOUNT_FORMAT_ERROR"}
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(rs["err_code"], @ts_err_accformat_code, "添加超级管理员#{@tc_man_name1}失败!")
            assert_equal(rs["err_msg"], @ts_err_accformat, "添加超级管理员#{@tc_man_name1}失败!")
            assert_equal(rs["err_desc"], @ts_err_accformat_desc, "添加超级管理员#{@tc_man_name1}失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            # @iam_obj.del_manager(@tc_man_name1)
        }
    end

}
