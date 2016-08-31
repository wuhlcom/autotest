#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_018", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_usr   = "15859031512"
        @tc_usr_pw      = "123456"
        @tc_usr_regargs = {type: "account", cond: @tc_phone_usr}
        @tc_newPwd1     = "12345"
        @tc_newPwd2     = "aa12347890aa12347890aa12347890121"
    end

    def process

        operate("1��ssh��¼IAM��������") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")
        }

        operate("2����¼�û���ȡaccess_tokenֵ��uid�ţ�") {
        }

        operate("3���޸����룬�����볤���ڷ�Χ֮�⣻") {
            rs    = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
            token = rs["access_token"]
            uid   = rs["uid"]
            p "���������������5���ַ�".encode("GBK")
            tip = "���������������5���ַ�"
            p rs = @iam_obj.mofify_user_pwd(@tc_usr_pw, @tc_newPwd1, uid, token)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_newpw_format_code, rs["err_code"], "#{tip}����code����!")
            assert_equal(@ts_err_newpw_format_msg, rs["err_msg"], "#{tip}����msg����")
            assert_equal(@ts_err_newpw_format_desc, rs["err_desc"], "#{tip}����desc����!")
            p "���������������33���ַ�".encode("GBK")
            tip = "���������������33���ַ�"
            p rs = @iam_obj.mofify_user_pwd(@tc_usr_pw, @tc_newPwd2, uid, token)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_newpw_format_code, rs["err_code"], "#{tip}����code����!")
            assert_equal(@ts_err_newpw_format_msg, rs["err_msg"], "#{tip}����msg����")
            assert_equal(@ts_err_newpw_format_desc, rs["err_desc"], "#{tip}����desc����!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
        }
    end

}
