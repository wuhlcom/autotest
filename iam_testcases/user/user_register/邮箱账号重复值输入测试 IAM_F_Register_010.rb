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

        operate("1��ssh��¼IAM��������") {
        }

        operate("2��ʹ������ע���û���") {
            p @rs1 = @iam_obj.register_emailusr(@ts_email_usr, @ts_email_pw, 1)
            assert_equal(1, @rs1["result"], "ʹ����ȷ�ַ�ע��ʱ��ע��ʧ��")
        }

        operate("3���ٴ�ע��һ���û������仹ʹ�ò���2������") {
            tip = "�ٴ�ע��һ���û������仹ʹ�ò���2������"
            p rs  = @iam_obj.register_emailusr(@ts_email_usr, @ts_email_pw, 1)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_acc_exists_code, rs["err_code"], "#{tip}����code����!")
            assert_equal(@ts_err_acc_exists, rs["err_msg"], "#{tip}����msg����")
            assert_equal(@ts_err_acc_exists_desc, rs["err_desc"], "#{tip}����desc����!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.usr_delete_usr(@ts_email_usr, @ts_email_pw)
        }
    end

}
