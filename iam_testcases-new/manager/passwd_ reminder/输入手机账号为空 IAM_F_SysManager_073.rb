#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_073", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_man_name=""
    end

    def process

        operate("1��SSH��¼IAMϵͳ��") {
        }

        operate("2���ֻ���Ϊ�ա���ȡ�ֻ���֤�룻") {
            rs = @iam_obj.request_mobile_code(@tc_man_name)
           puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
           puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
           puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
           assert_equal(@ts_err_phonull_msg, rs["err_msg"], "�޸������ʹ�þ����벻Ӧ�õ�¼�ɹ�!")
           assert_equal(@ts_err_phonull_errcode, rs["err_code"], "�޸������ʹ�þ����벻Ӧ�õ�¼�ɹ�!")
           assert_equal(@ts_err_phonull_code_desc, rs["err_desc"], "�޸������ʹ�þ����벻Ӧ�õ�¼�ɹ�!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
