#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_027", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_man_name1 = "13760281503"
        @tc_nickname1     = "a"*33
        @tc_passwd        = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、新增一个管理员，nickname为33个字符；") {
            @iam_obj.del_manager(@tc_man_name1)
            puts "添加超级管理员账户为:#{@tc_man_name1}".to_gbk
            puts "昵称为'#{@tc_nickname1},昵称为长度为#{@tc_nickname1.size}".to_gbk
            p rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_nickformat_code, rs["err_code"], "添加#{@tc_nickname1.size}位成功!")
            assert_equal(@ts_err_nickformat, rs["err_msg"], "添加#{@tc_nickname1.size}位成功!")
            assert_equal(@ts_err_nickformat_desc, rs["err_desc"], "添加#{@tc_nickname1.size}位成功!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.del_manager(@tc_man_name1)
        }
    end

}
