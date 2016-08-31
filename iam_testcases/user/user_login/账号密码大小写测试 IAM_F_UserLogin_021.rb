#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {

    attr = {"id" => "IAM_F_UserLogin_021", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_usr_pwd_new = "liluping"
    end

    def process


        operate("1��ssh��¼IAM��������") {
            @rs= @iam_obj.email_usr_reg(@ts_email_usr, @ts_email_pw, @ts_email_regargs)
            assert_equal(@ts_add_rs, @rs["result"], "�û�#{@ts_phone_usr}ע��ʧ��")


            p @md = @iam_obj.usr_modify_pw_step(@ts_email_usr, @ts_email_pw, @ts_email_pw, @tc_usr_pwd_new)
            assert_equal(@ts_add_rs, @md["result"], "�޸�����Ϊ#{@tc_usr_pwd_new}ʱʧ��")
        }

        operate("2���û���¼���˺š��������뺬�д�Сд��ĸ��") {
            rs  = @iam_obj.user_login(@ts_phone_usr.upcase, @tc_usr_pwd_new)
            tip = "�û���¼���˺����뺬�д�Сд��ĸ"
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_login_code, rs["err_code"], "#{tip}����code����!")
            assert_equal(@ts_err_login, rs["err_msg"], "#{tip}����msg����")
            assert_equal(@ts_err_login_desc, rs["err_desc"], "#{tip}����desc����!")

            rs  = @iam_obj.user_login(@ts_phone_usr, @tc_usr_pwd_new.upcase)
            tip = "�û���¼���������뺬�д�Сд��ĸ"
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_login_code, rs["err_code"], "#{tip}����code����!")
            assert_equal(@ts_err_login, rs["err_msg"], "#{tip}����msg����")
            assert_equal(@ts_err_login_desc, rs["err_desc"], "#{tip}����desc����!")
        }
    end


    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.usr_delete_usr(@ts_email_usr, @ts_email_pw)
            @iam_obj.usr_delete_usr(@ts_email_usr, @tc_usr_pwd_new)
        }
    end

}
