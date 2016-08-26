#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_017", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_man_name1 = " SysManager_017@zhilutec.com"
        @tc_man_name2 = "Manager_017@zhilutec.com "
        @tc_nickname      = "SysManager_017"
        @tc_passwd        = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、账号前后带空格时，新增管理员：") {
            #如果管理员已经存在则先删除
            @iam_obj.del_manager(@tc_man_name1.strip)
            puts "添加超级管理员账户为:'#{@tc_man_name1}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员'#{@tc_man_name1}'失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员'#{@tc_man_name1}'失败!")

            #如果管理员已经存在则先删除
            @iam_obj.del_manager(@tc_man_name2.strip)
            puts "添加超级管理员账户为:'#{@tc_man_name2}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name2, @tc_nickname, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员'#{@tc_man_name2}'失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员'#{@tc_man_name2}'失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.del_manager(@tc_man_name1.strip)
            @iam_obj.del_manager(@tc_man_name2.strip)
        }
    end

}
