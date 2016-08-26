#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_020", "level" => "P1", "auto" => "n"}

    def prepare
        # ���źŶ�:133/153/180/181/189/177��
        # ��ͨ�Ŷ�:130/131/132/155/156/185/186/145/176��
        # �ƶ��ŶΣ�134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
        @tc_phone_nums=[]
        # 130-139  #180-189 # 150-153 155-159
        10.times do |num|
            @tc_phone_nums.push "13#{num}66668888"
            @tc_phone_nums.push "18#{num}66668888"
            @tc_phone_nums.push "15#{num}66668888" unless num == "4"
        end
        # 145 147 176 177 178
        str = "66668888"
        @tc_phone_nums.push "145#{str}", "147#{str}", "176#{str}", "177#{str}", "178#{str}"
        @tc_phone_nums.sort!
        @tc_nickname1 = "phone_account"
        @tc_passwd    = "123456"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3��ʹ�ò�ͬ�ֻ��κ�������һ������Ա��") {
            #�������Ա�Ѿ���������ɾ��
            @tc_phone_nums.each do |phone_num|
                @iam_obj.del_manager(phone_num)
                puts "��ӳ�������Ա�˻�Ϊ:'#{phone_num}'".to_gbk
                rs = @iam_obj.manager_add(phone_num, @tc_nickname1, @tc_passwd)
                # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
                puts "RESULT MSG:#{rs['msg']}".encode("GBK")
                assert_equal(@ts_add_rs, rs["result"], "��ӳ�������Ա'#{phone_num}'ʧ��!")
                assert_equal(@ts_add_msg, rs["msg"], "��ӳ�������Ա'#{phone_num}'ʧ��!")
            end
        }


    end

    def clearup

        operate("1.�ָ�Ĭ������") {
            @tc_phone_nums.each do |phone_num|
                puts "delete manager '#{phone_num}'"
                @iam_obj.del_manager(phone_num)
            end
        }

    end

}
