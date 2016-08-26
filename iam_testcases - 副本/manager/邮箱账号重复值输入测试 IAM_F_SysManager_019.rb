#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_019", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_man_name1 = "SysManager_019@zhilutec.com"
        @tc_nickname      = "SysManager_019"
        @tc_passwd        = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、执行新增一个管理员：") {
            #如果管理员已经存在则先删除
            @iam_obj.del_manager(@tc_man_name1)
            puts "添加超级管理员账户为:#{@tc_man_name1}".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(rs["result"], @ts_add_rs, "添加超级管理员失败!")
            assert_equal(rs["msg"], @ts_add_msg, "添加超级管理员失败!")
        }

        operate("4、重复步骤3；") {
            puts "添加超级管理员账户为:#{@tc_man_name1}".to_gbk
            p rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname, @tc_passwd)
            # {"err_code"=>"5006", "err_msg"=>"\u5E10\u53F7\u5DF2\u5B58\u5728", "err_desc"=>"E_ACCOUNT_EXISTS_ERROR"}
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_acc_exists_code, rs["err_code"], "添加重复超级管理员#{@tc_man_name1}应提示失败!")
            assert_equal(@ts_err_acc_exists, rs["err_msg"], "添加重复超级管理员#{@tc_man_name1}应提示失败!")
            assert_equal(@ts_err_acc_exists_desc, rs["err_desc"], "添加重复超级管理员#{@tc_man_name1}应提示失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.del_manager(@tc_man_name1)
        }
    end

}
