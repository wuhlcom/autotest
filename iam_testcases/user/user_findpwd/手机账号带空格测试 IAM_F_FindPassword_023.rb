#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_023", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_phone_num1 = " 13823652368"
        @tc_phone_num2 = "13823 652367"
        @tc_phone      = [@tc_phone_num1, @tc_phone_num2]
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2���ֻ�����������пո�") {
            @tc_phone.each do |phone|
                p cmd = @ts_mobilecode_url + phone
                tip = "�����ֻ�����#{phone}"
                Net::SSH.start(@ts_ssh_host, @ts_ssh_usr, :password => @ts_ssh_pwd) do |ssh|
                    rs = ssh.exec!(cmd)
                    rs=~/\{"err_code":"(\d+)","err_msg":"(.+)","err_desc":"(.+)"\}/
                    puts "RESULT err_msg:#{$1}".encode("GBK")
                    puts "RESULT err_code:#{$2}".encode("GBK")
                    puts "RESULT err_desc:#{$3}".encode("GBK")
                    assert_equal(@ts_err_phoneerr_code, $1, "#{tip}����code����!")
                    assert_equal(@ts_err_phoneerr_msg, $2, "#{tip}����msg����")
                    assert_equal(@ts_err_phoneerr_desc, $3, "#{tip}����desc����!")
                end
            end
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
