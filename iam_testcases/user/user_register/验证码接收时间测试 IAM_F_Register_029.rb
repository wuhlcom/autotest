#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_029", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_mobile_phone  = "15815642765"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2���ֱ�ʹ����ͨ�����š��ƶ��ֻ����������֤���ȡ���ԣ�") {
            rs = ""
            n = 0
            Thread.new do
                p rs = @iam_obj.request_mobile_code(@tc_mobile_phone)
            end
            11.times do
                n += 1
                break if rs["mobile"] == @tc_mobile_phone && !rs["code"].nil?
                sleep 1
            end
            assert(n<=10, "10��֮��δ�յ���֤����ţ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
