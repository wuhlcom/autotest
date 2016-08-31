#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_036", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_num    = "15814035400"
        @tc_phone_pw     = "123123"
        @tc_phone_pw_new = "123456"
        @tc_usr_regargs  = {type: "account", cond: @tc_phone_num}
        @tc_wait_time    = 125 #���ӳ٣�����5s
    end

    def process

        operate("1��ssh��¼IAM��������") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_num, @tc_phone_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "�û�#{@tc_phone_num}ע��ʧ��")
        }

        operate("2����ȡ�ֻ���֤�룻") {
            re = @iam_obj.request_mobile_code(@tc_phone_num) #������֤��
            p @code = re["code"]
            refute(@code.nil?, "��ȡ��֤��ʧ��")
        }

        operate("3��2�����Ժ���������һأ�") {
            sleep @tc_wait_time
            tip = "2�����Ժ���������һ�"
            rs  = @iam_obj.usr_modpw_mobile_bycode(@tc_phone_num, @tc_phone_pw_new, @code)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_pcoderr_code, rs["err_code"], "#{tip}����code����!")
            assert_equal(@ts_err_pcoderr_msg, rs["err_msg"], "#{tip}����msg����")
            assert_equal(@ts_err_pcoderr_desc, rs["err_desc"], "#{tip}����desc����!")

        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.usr_delete_usr(@tc_phone_num, @tc_phone_pw)
            @iam_obj.usr_delete_usr(@tc_phone_num, @tc_phone_pw_new)
        }
    end

}
