#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_002", "level" => nil, "auto" => "n"}

    def prepare
        @tc_usr_name = "liluping@zhilutec.com"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2��������������һ����룻") {
            rs = @iam_obj.find_pwd_for_email(@tc_usr_name)
            assert_equal(1, rs["result"], "�ʼ��һ����뷢��ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
