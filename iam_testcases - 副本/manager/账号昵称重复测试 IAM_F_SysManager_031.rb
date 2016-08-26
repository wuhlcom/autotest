#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_031", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_man_name1 = "15860281111"
        @tc_nickname1 = "niubee"
        @tc_man_name2 = "15860281112"
        @tc_nickname2 = "niubee"
        @tc_passwd    = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、新增一个管理员，nickname为aa1234；") {
            @iam_obj.del_manager(@tc_man_name1)
            puts "添加超级管理员账户为:#{@tc_man_name1}，昵称为'#{@tc_nickname1}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员#{@tc_man_name1},昵称为'#{@tc_nickname1}'失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员#{@tc_man_name1},昵称为'#{@tc_nickname1}'失败!")
        }

        operate("4、再次新增管理员，nickname为aa1234；") {
            @iam_obj.del_manager(@tc_man_name2)
            puts "添加超级管理员账户为:#{@tc_man_name2}，昵称为'#{@tc_nickname2}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name2, @tc_nickname2, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员#{@tc_man_name2},昵称为'#{@tc_nickname2}'失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员#{@tc_man_name2},昵称为'#{@tc_nickname2}'失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.del_manager(@tc_man_name1.strip)
            @iam_obj.del_manager(@tc_man_name2.strip)
        }
    end

}
