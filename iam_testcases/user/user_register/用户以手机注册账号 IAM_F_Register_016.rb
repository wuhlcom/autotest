#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_016", "level" => nil, "auto" => "n"}

    def prepare
        @tc_usr_phone = "15814037401"
        @tc_pwd       = "123123"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��֤�룻") {

        }

        operate("3���ֻ�ע���û���") {
            @rs = @iam_obj.register_phoneusr(@tc_usr_phone, @tc_pwd)
            assert_equal(1, @rs["result"], "�ֻ�ע���û�ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_usr(@tc_usr_phone, @tc_pwd)
            end
        }
    end

}
