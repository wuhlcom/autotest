#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_026", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_man_name1 = "13760281500"
        @tc_nickname1     = "h"

        @tc_man_name2 = "13760281501"
        @tc_nickname2     = "5"*32

        @tc_man_name3 = "13760281502"
        @tc_nickname3     = "autotest_ttttt"

        @tc_man_name4 = "13760281503"
        @tc_nickname4     = "饭没了_SS_03"
        @tc_passwd        = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、新增一个管理员，nickname为单个字符、32字符、字母数字下划线中文组合；") {
            @iam_obj.del_manager(@tc_man_name1)
            puts "添加超级管理员账户为:#{@tc_man_name1}，昵称为'#{@tc_nickname1}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员#{@tc_man_name1}失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员#{@tc_man_name1}失败!")

            @iam_obj.del_manager(@tc_man_name2)
            puts "添加超级管理员账户为:#{@tc_man_name2}，昵称为'#{@tc_nickname2}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name2, @tc_nickname2, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员#{@tc_man_name2}失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员#{@tc_man_name2}失败!")

            @iam_obj.del_manager(@tc_man_name3)
            puts "添加超级管理员账户为:#{@tc_man_name3}，昵称为'#{@tc_nickname3}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name3, @tc_nickname3, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员#{@tc_man_name3}失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员#{@tc_man_name3}失败!")

            @iam_obj.del_manager(@tc_man_name4)
            puts "添加超级管理员账户为:#{@tc_man_name4}，昵称为'#{@tc_nickname4}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name4, @tc_nickname4, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员#{@tc_man_name4}失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员#{@tc_man_name4}失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.del_manager(@tc_man_name1)
            @iam_obj.del_manager(@tc_man_name2)
            @iam_obj.del_manager(@tc_man_name3)
            @iam_obj.del_manager(@tc_man_name4)
        }
    end

}
