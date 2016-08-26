#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_013", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_man_name1 = "klwn20@163.com"
        @tc_man_name2 = "1420557566@qq.com"
        @tc_man_name3 = "zhilu_123456789012345678@126.com"
        @tc_man_name4 = "NEWMAN@sina.com.cn"
        @tc_man_name5 = "ADDx_550@sohu.com"
        @tc_man_name6 = "zhihudasheng@yahoo.com.cn"
        @tc_man_name7 = "ggmmlll@gmail.com"
        @tc_man_name8 = "hhhotmm_222@hotmail.com"
        @tc_man_name9 = "zhilu_ttec_5522@zhilutec.com"
        @tc_man_names =[@tc_man_name1, @tc_man_name2, @tc_man_name4, @tc_man_name5, @tc_man_name6, @tc_man_name7, @tc_man_name8]
        @tc_nickname      = "mail_account"
        @tc_passwd        = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、执行新增一个管理员，") {
            #如果管理员已经存在则先删除
        }

        operate("用例中列出邮箱都要测试一遍；") {
            @tc_man_names.each do |account|
                @iam_obj.del_manager(account)
                puts "添加超级管理员账户为:'#{account}'".to_gbk
                rs = @iam_obj.manager_add(account, @tc_nickname, @tc_passwd)
                puts "RESULT MSG:#{rs['msg']}".encode("GBK")
                assert_equal(@ts_add_rs, rs["result"], "添加超级管理员'#{account}'失败!")
                assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员'#{account}'失败!")
            end
        }

        operate("4、邮箱长度32字符：") {
            @iam_obj.del_manager(@tc_man_name3)
            puts "添加超级管理员账户为:#{@tc_man_name3},长度为#{@tc_man_name3.size}".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name3, @tc_nickname, @tc_passwd)
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员#{@tc_man_name3}失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员#{@tc_man_name3}失败!")
        }

        operate("5、邮箱输入含有字母、数字、下划线字符：") {
            @iam_obj.del_manager(@tc_man_name9)
            puts "添加超级管理员账户为:#{@tc_man_name9}".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name9, @tc_nickname, @tc_passwd)
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加超级管理员#{@tc_man_name9}失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员#{@tc_man_name9}失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @tc_man_names.push(@tc_man_name3, @tc_man_name9)
            @tc_man_names.each do |acc|
                puts "delete manager:#{acc}"
                @iam_obj.del_manager(acc)
            end
        }
    end

}
