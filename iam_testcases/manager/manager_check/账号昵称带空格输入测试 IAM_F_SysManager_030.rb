#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_030", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_man_name1 = "15860281111"
        @tc_nickname1 = " niub"
        @tc_man_name2 = "15860282222"
        @tc_nickname2 = "niub "
        @tc_man_name3 = "1586028333"
        @tc_nickname3 = "niu b"
        @tc_passwd    = "123456"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3������һ������Ա��nickname���пո�") {
            @iam_obj.del_manager(@tc_man_name1.strip)
            puts "��ӳ�������Ա�˻�Ϊ:#{@tc_man_name1}���ǳ�Ϊ'#{@tc_nickname1}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Ա#{@tc_man_name1},�ǳ�Ϊ'#{@tc_nickname1}'ʧ��!")
            assert_equal(@ts_add_msg, rs["msg"], "��ӳ�������Ա#{@tc_man_name1},�ǳ�Ϊ'#{@tc_nickname1}'ʧ��!")

            @iam_obj.del_manager(@tc_man_name2.strip)
            puts "��ӳ�������Ա�˻�Ϊ:#{@tc_man_name2}���ǳ�Ϊ'#{@tc_nickname2}'".to_gbk
            rs = @iam_obj.manager_add(@tc_man_name2, @tc_nickname2, @tc_passwd)
            # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Ա#{@tc_man_name2},�ǳ�Ϊ'#{@tc_nickname2}'ʧ��!")
            assert_equal(@ts_add_msg, rs["msg"], "��ӳ�������Ա#{@tc_man_name2},�ǳ�Ϊ'#{@tc_nickname2}'ʧ��!")

            puts "��ӳ�������Ա�˻�Ϊ:#{@tc_man_name3}".to_gbk
            puts "�ǳ�Ϊ'#{@tc_nickname3}',�ǳ�Ϊ����Ϊ'#{@tc_nickname3.size}'".to_gbk
            p rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname3, @tc_passwd)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_nickformat_code, rs["err_code"], "��ӳ�������Ա#{@tc_man_name3},�ǳ�Ϊ'#{@tc_nickname3}'�ɹ�!")
            assert_equal(@ts_err_nickformat, rs["err_msg"], "��ӳ�������Ա#{@tc_man_name3},�ǳ�Ϊ'#{@tc_nickname3}'�ɹ�!")
            assert_equal(@ts_err_nickformat_desc, rs["err_desc"], "��ӳ�������Ա#{@tc_man_name3},�ǳ�Ϊ'#{@tc_nickname3}'�ɹ�!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.del_manager(@tc_man_name1.strip)
            @iam_obj.del_manager(@tc_man_name2.strip)
        }
    end

}
