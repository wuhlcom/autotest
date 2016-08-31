#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_010", "level" => "P3", "auto" => "n"}

    def prepare

    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、使用邮箱注册用户；") {
            p @rs1 = @iam_obj.register_emailusr(@ts_email_usr, @ts_email_pw, 1)
            assert_equal(1, @rs1["result"], "使用正确字符注册时，注册失败")
        }

        operate("3、再次注册一个用户，邮箱还使用步骤2的邮箱") {
            tip = "再次注册一个用户，邮箱还使用步骤2的邮箱"
            p rs  = @iam_obj.register_emailusr(@ts_email_usr, @ts_email_pw, 1)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_acc_exists_code, rs["err_code"], "#{tip}返回code错误!")
            assert_equal(@ts_err_acc_exists, rs["err_msg"], "#{tip}返回msg错误")
            assert_equal(@ts_err_acc_exists_desc, rs["err_desc"], "#{tip}返回desc错误!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_delete_usr(@ts_email_usr, @ts_email_pw)
        }
    end

}
