#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_025", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_man_name1 = "13760281500"
        @tc_nickname1     = "13760281500"
        @tc_passwd        = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、手机号正常输入，新增一个管理员；") {
            @iam_obj.del_manager(@tc_man_name1.strip)
            puts "添加超级管理员账户为:#{@tc_man_name1}".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员失败!")
        }

        operate("4、使用步骤3的手机号再次新增管理员") {
            puts "再次添加超级管理员账户为:#{@tc_man_name1}".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_acc_exists_code, rs["err_code"], "添加重复手机号#{@tc_man_name1}应提示失败!")
            assert_equal(@ts_err_acc_exists, rs["err_msg"], "添加重复手机号#{@tc_man_name1}应提示失败!")
            assert_equal(@ts_err_acc_exists_desc, rs["err_desc"], "添加重复手机号#{@tc_man_name1}应提示失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
