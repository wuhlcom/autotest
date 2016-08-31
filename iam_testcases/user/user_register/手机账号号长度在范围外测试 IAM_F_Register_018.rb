#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_018", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_phone_num_12 = "158140374001"
        @tc_phone_num_10 = "1581403740"
        @tc_phone_num    = [@tc_phone_num_12, @tc_phone_num_10]
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2���ֻ����볤�ȴ���11λ����С��11λ��") {
            @tc_phone_num.each do |num|
                tip  = "�ֻ����볤�ȴ���11λ����С��11λ"
                rs = @iam_obj.request_mobile_code(num)
                puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
                puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
                puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
                assert_equal(@ts_err_phoneerr_code, rs["err_code"], "#{tip}����code����!")
                assert_equal(@ts_err_phoneerr_msg, rs["err_msg"], "#{tip}����msg����")
                assert_equal(@ts_err_phoneerr_desc, rs["err_desc"], "#{tip}����desc����!")
            end
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
