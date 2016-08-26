#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_017_01", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_man_name1 = "Sys Manager_017@zhilutec.com"
        @tc_man_name2 = "SysManager_017@zhilu tec.com"
        @tc_man_name3 = "SysManager_017@zhilutec.c om "
        @tc_man_names =[@tc_man_name1, @tc_man_name2, @tc_man_name3]
        @tc_nickname   = "SysManager_017_01"
        @tc_passwd     = "123456"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����ȡ��¼����Ա��id�ź�tokenֵ��") {
        }

        operate("3���˺��м���ո���������Ա��") {
            @tc_man_names.each do |acc|
                puts "��ӳ�������Ա�˻�Ϊ:'#{acc}'".to_gbk
                rs = @iam_obj.manager_add(acc, @tc_nickname, @tc_passwd)
                # {"err_code":"5003","err_msg":"\u5e10\u53f7\u683c\u5f0f\u9519\u8bef","err_desc":"E_ACCOUNT_FORMAT_ERROR"}
                puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
                puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
                puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
                assert_equal(@ts_err_accformat_code, rs["err_code"], "��ӳ�������Ա'#{acc}'ʧ��!")
                assert_equal(@ts_err_accformat, rs["err_msg"], "��ӳ�������Ա'#{acc}'ʧ��!")
                assert_equal(@ts_err_accformat_desc, rs["err_desc"], "��ӳ�������Ա'#{acc}'ʧ��!")
            end
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
