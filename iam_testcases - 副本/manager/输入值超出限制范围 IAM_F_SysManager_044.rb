#
# description:备注超过限制长度会自动截断
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_044", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_man_name = "IAM_F_SysManager@126.com"
        @tc_nickname = "nick"
        @tc_passwd   = "123456"
        @tc_rcode    = "2"
        comment1     = "经常练习，学习才能进步"*9
        comment2     = "~!@#$%^&*()_+{}|\":?><-=[];'\\.,/'"
        comment3     = "abdefghijklmnopqrstuvwxyzz"
        @tc_comment  = comment1+comment2+comment3+comment1
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、新增一个管理员，comments为256字符；") {
            #如果管理员已经存在则先删除
            @iam_obj.del_manager(@tc_man_name)
            puts "新增管理员:‘#{@tc_man_name}’，备注长为'#{@tc_comment.size}'".encode("GBK")
            rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd, @tc_rcode, @tc_comment)
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "新增管理员:‘#{@tc_man_name}’，备注长为#{@tc_comment.size}失败!")
            assert_equal(@ts_add_msg, rs["msg"], "新增管理员:‘#{@tc_man_name}’，备注长为'#{@tc_comment.size}'失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.del_manager(@tc_man_name)
        }
    end

}
