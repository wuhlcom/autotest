#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_040", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_phone_usr    = "15845031512"
        @tc_usr_pw       = "123456"
        @tc_usr_regargs  = {type: "account", cond: @tc_phone_usr}
        @tc_phone_pw_new = "123123"
    end

    def process

        operate("1��ssh��¼IAM��������") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_usr}ע��ʧ��")
        }

        operate("2����ȡ�ֻ���֤�룻") {
        }

        operate("3���޸����룻") {
            @rs = @iam_obj.usr_modpw_mobile(@tc_phone_usr, @tc_phone_pw_new)
            assert_equal(1, @rs["result"], "�޸�����ʧ�ܣ�")
        }

        operate("4��ʹ�þ������¼��") {
            tip = "ʹ�þ������¼"
            rs  = @iam_obj.user_login(@tc_phone_usr, @tc_usr_pw)
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
            if @rs["result"] == 1
                @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_phone_pw_new)
            else
                @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
            end
        }
    end

}
