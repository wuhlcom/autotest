#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_031", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_man_name1 = "15860281111"
        @tc_nickname1 = "niubee"
        @tc_man_name2 = "15860281112"
        @tc_nickname2 = "niubee"
        @tc_passwd    = "123456"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3������һ������Ա��nicknameΪaa1234��") {
            @iam_obj.del_manager(@tc_man_name1)
            puts "��ӳ�������Ա�˻�Ϊ:#{@tc_man_name1}���ǳ�Ϊ'#{@tc_nickname1}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Ա#{@tc_man_name1},�ǳ�Ϊ'#{@tc_nickname1}'ʧ��!")
            assert_equal(@ts_add_msg, rs["msg"], "��ӳ�������Ա#{@tc_man_name1},�ǳ�Ϊ'#{@tc_nickname1}'ʧ��!")
        }

        operate("4���ٴ���������Ա��nicknameΪaa1234��") {
            @iam_obj.del_manager(@tc_man_name2)
            puts "��ӳ�������Ա�˻�Ϊ:#{@tc_man_name2}���ǳ�Ϊ'#{@tc_nickname2}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name2, @tc_nickname2, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Ա#{@tc_man_name2},�ǳ�Ϊ'#{@tc_nickname2}'ʧ��!")
            assert_equal(@ts_add_msg, rs["msg"], "��ӳ�������Ա#{@tc_man_name2},�ǳ�Ϊ'#{@tc_nickname2}'ʧ��!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.del_manager(@tc_man_name1.strip)
            @iam_obj.del_manager(@tc_man_name2.strip)
        }
    end

}
