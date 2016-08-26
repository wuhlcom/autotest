#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_001", "level" => nil, "auto" => "n"}

    def prepare
        @tc_user_name = "liluping@zhilutec.com"
        @tc_user_pwd  = "123123"
    end

    def process

        operate("1��ssh��¼IAM��������") {

        }

        operate("2��ʹ������ע���û���") {
            @rs = @iam_obj.register_emailusr(@tc_user_name, @tc_user_pwd, 1)
            assert_equal(1, @rs["result"], "ʹ������ע���û�ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name, @tc_user_pwd)
            end
        }
    end

}
