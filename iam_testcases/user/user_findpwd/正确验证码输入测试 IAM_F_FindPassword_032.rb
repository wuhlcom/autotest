#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_032", "level" => "P1", "auto" => "n"}

    def prepare
       
    end

    def process

        operate("1��ssh��¼IAM��������") {
            @rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
            assert_equal(@ts_add_rs, @rs["result"], "�û�#{@ts_phone_usr}ע��ʧ��")
        }

        operate("2����ȡ�ֻ���֤�룻") {
        }

        operate("3���޸����룻") {

        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs["result"] == 1
                @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
            end
        }
    end

}
