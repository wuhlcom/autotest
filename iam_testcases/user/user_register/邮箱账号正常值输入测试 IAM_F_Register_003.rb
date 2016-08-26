#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_003", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_user_name_163     = "autotest@163.com"
        @tc_user_name_qq      = "autotest@qq.com"
        @tc_user_name_126     = "autotest@126.com"
        @tc_user_name_sina    = "autotest@sina.com"
        @tc_user_name_sohu    = "autotest@sohu.com"
        @tc_user_name_yahoo   = "autotest@yahoo.com"
        @tc_user_name_gmail   = "autotest@gmail.com"
        @tc_user_name_hotmail = "autotest@hotmail.com"
        @tc_user_name_32      = "zhilukeji1zhilukeji@gamil.com"
        @tc_user_name_ul      = "zhilu123_123@gmail.com"
        @tc_user_pwd          = "123123"
    end

    def process

        operate("1、ssh登录IAM服务器；") {

        }

        operate("2、使用邮箱注册用户；（使用不同的邮箱进行测试）") {
            p "测试常用邮箱是否可以正常注册".encode("GBK")
            p "测试163邮箱".encode("GBK")
            @rs1 = @iam_obj.register_emailusr(@tc_user_name_163, @tc_user_pwd, 1)
            assert_equal(1, @rs1["result"], "使用163邮箱注册用户失败")
            p "测试qq邮箱".encode("GBK")
            @rs2 = @iam_obj.register_emailusr(@tc_user_name_qq, @tc_user_pwd, 1)
            assert_equal(1, @rs2["result"], "使用qq邮箱注册用户失败")
            p "测试126邮箱".encode("GBK")
            @rs3 = @iam_obj.register_emailusr(@tc_user_name_126, @tc_user_pwd, 1)
            assert_equal(1, @rs3["result"], "使用126邮箱注册用户失败")
            p "测试sina邮箱".encode("GBK")
            @rs4 = @iam_obj.register_emailusr(@tc_user_name_sina, @tc_user_pwd, 1)
            assert_equal(1, @rs4["result"], "使用sina邮箱注册用户失败")
            p "测试sohu邮箱".encode("GBK")
            @rs5 = @iam_obj.register_emailusr(@tc_user_name_sohu, @tc_user_pwd, 1)
            assert_equal(1, @rs5["result"], "使用sohu邮箱注册用户失败")
            p "测试yahoo邮箱".encode("GBK")
            @rs6 = @iam_obj.register_emailusr(@tc_user_name_yahoo, @tc_user_pwd, 1)
            assert_equal(1, @rs6["result"], "使用yahoo邮箱注册用户失败")
            p "测试gmail邮箱".encode("GBK")
            @rs7 = @iam_obj.register_emailusr(@tc_user_name_gmail, @tc_user_pwd, 1)
            assert_equal(1, @rs7["result"], "使用gmail邮箱注册用户失败")
            p "测试hotmail邮箱".encode("GBK")
            @rs8 = @iam_obj.register_emailusr(@tc_user_name_hotmail, @tc_user_pwd, 1)
            assert_equal(1, @rs8["result"], "使用hotmail邮箱注册用户失败")
            p "测试输入邮箱长度为32个字符".encode("GBK")
            @rs9 = @iam_obj.register_emailusr(@tc_user_name_32, @tc_user_pwd, 1)
            assert_equal(1, @rs9["result"], "使用长度为32个字符的用户名注册失败")
            p "测试邮箱输入框中输入字母、数字、下划线的字符".encode("GBK")
            @rs10 = @iam_obj.register_emailusr(@tc_user_name_ul, @tc_user_pwd, 1)
            assert_equal(1, @rs10["result"], "使用字母、数字、下划线的字符的用户名注册失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs1["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_163, @tc_user_pwd)
            end
            if @rs2["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_qq, @tc_user_pwd)
            end
            if @rs3["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_126, @tc_user_pwd)
            end
            if @rs4["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_sina, @tc_user_pwd)
            end
            if @rs5["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_sohu, @tc_user_pwd)
            end
            if @rs6["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_yahoo, @tc_user_pwd)
            end
            if @rs7["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_gmail, @tc_user_pwd)
            end
            if @rs8["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_hotmail, @tc_user_pwd)
            end
            if @rs9["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_32, @tc_user_pwd)
            end
            if @rs10["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_ul, @tc_user_pwd)
            end
        }
    end

}
