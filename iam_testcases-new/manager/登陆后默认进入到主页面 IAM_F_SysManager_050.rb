#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_050", "level" => "P1", "auto" => "n"}

    def prepare

    end

    def process

        operate("1��ssh��¼��IAM��������") {
        }

        operate("2����¼֪·����Ա��") {
            rs = @iam_obj.manager_login(@ts_admin_log_name,@ts_admin_log_pw)
            # {"result":1,"name":"admin@zhilutec.com","nickname":"\u77e5\u8def\u7ba1\u7406\u5458",
            # "uid":"1","role_code":"1","token":"e4f0326fa441186b18dcd66dc4509466"}
            puts "RESULT result:#{rs['result']}".encode("GBK")
            assert_equal(@ts_admin_log_rs, rs["result"], "����Ա������Ϣ����!")

            puts "RESULT name:#{rs['name']}".encode("GBK")
            assert_equal(@ts_admin_log_name, rs["name"], "����Ա����name��Ϣ����!")

            puts "RESULT nickname:#{rs['nickname']}".encode("GBK")
            assert_equal(@ts_admin_log_nickname, rs["nickname"], "����Ա����nickname��Ϣ����!")

            puts "RESULT uid:#{rs['uid']}".encode("GBK")
            assert_equal(@ts_admin_log_uid, rs["uid"], "����Ա������Ϣ����!")

            puts "RESULT role_code:#{rs['role_code']}".encode("GBK")
            assert_equal(@ts_admin_rcode, rs["role_code"], "����Ա����role_code��Ϣ����!")

            puts "RESULT token:#{rs['token']}".encode("GBK")
            refute_nil(rs["token"], "token!")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
