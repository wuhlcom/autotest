#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_030", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_man_name1 = "15860281111"
        @tc_nickname1 = " niub"
        @tc_man_name2 = "15860282222"
        @tc_nickname2 = "niub "
        @tc_man_name3 = "1586028333"
        @tc_nickname3 = "niu b"
        @tc_passwd    = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、新增一个管理员，nickname带有空格；") {
            @iam_obj.del_manager(@tc_man_name1.strip)
            puts "添加超级管理员账户为:#{@tc_man_name1}，昵称为'#{@tc_nickname1}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员#{@tc_man_name1},昵称为'#{@tc_nickname1}'失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员#{@tc_man_name1},昵称为'#{@tc_nickname1}'失败!")

            @iam_obj.del_manager(@tc_man_name2.strip)
            puts "添加超级管理员账户为:#{@tc_man_name2}，昵称为'#{@tc_nickname2}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name2, @tc_nickname2, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员#{@tc_man_name2},昵称为'#{@tc_nickname2}'失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员#{@tc_man_name2},昵称为'#{@tc_nickname2}'失败!")

            puts "添加超级管理员账户为:#{@tc_man_name3}".to_gbk
            puts "昵称为'#{@tc_nickname3}',昵称为长度为'#{@tc_nickname3.size}'".to_gbk
            p rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname3, @tc_passwd)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_nickformat_code, rs["err_code"], "添加超级管理员#{@tc_man_name3},昵称为'#{@tc_nickname3}'成功!")
            assert_equal(@ts_err_nickformat, rs["err_msg"], "添加超级管理员#{@tc_man_name3},昵称为'#{@tc_nickname3}'成功!")
            assert_equal(@ts_err_nickformat_desc, rs["err_desc"], "添加超级管理员#{@tc_man_name3},昵称为'#{@tc_nickname3}'成功!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.del_manager(@tc_man_name1.strip)
            @iam_obj.del_manager(@tc_man_name2.strip)
        }
    end

}
