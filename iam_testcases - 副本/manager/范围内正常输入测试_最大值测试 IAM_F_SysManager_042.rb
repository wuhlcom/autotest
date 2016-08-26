#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_042", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_man_name = "IAM_F_SysManager@126.com"
        @tc_nickname = "nick"
        @tc_passwd   = "123456"
        @tc_rcode    = "2"
        comment1     = "������ϰ��ѧϰ���ܽ���"*9
        comment2     = "~!@#$%^&*()_+{}|\":?><-=[];'\\.,/'"
        comment3     = "abdefghijklmnopqrstuvwxyz"
        @tc_comment  = comment1+comment2+comment3+comment1

    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3������һ������Ա��commentsΪ255���ַ���") {
            #�������Ա�Ѿ���������ɾ��
            @iam_obj.del_manager(@tc_man_name)
            puts "��������Ա:��#{@tc_man_name}������ע��Ϊ'#{@tc_comment.size}'".encode("GBK")
            rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd, @tc_rcode, @tc_comment)
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "��������Ա:��#{@tc_man_name}������ע��Ϊ#{@tc_comment.size}ʧ��!")
            assert_equal(@ts_add_msg, rs["msg"], "��������Ա:��#{@tc_man_name}������ע��Ϊ'#{@tc_comment.size}'ʧ��!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.del_manager(@tc_man_name)
        }
    end

}
