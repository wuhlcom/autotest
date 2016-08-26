#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_021", "level" => "P4", "auto" => "n"}

    def prepare
        # @tc_phone_num1 = " 13823652368"
        @tc_phone_num2 = "13823 652367"
        # @tc_phone_num3 = "13823652367 "
        @tc_err_code   = "5002"
    end

    def process


        operate("1、ssh登录IAM服务器；") {

        }

        operate("2、输入手机号码带有空格；") {
            # p "手机号前面带空格".encode("GBK")
            # p @rs1 = @iam_obj.request_mobile_code(@tc_phone_num1)
            # assert(@rs1["code"], "使用手机号前面带空格注册用户失败")

            p "手机号中间带空格".encode("GBK")
            p @rs2 = @iam_obj.request_mobile_code(@tc_phone_num2)
            assert(@rs2["code"], "使用手机号中间带空格注册用户成功或者注册失败但错误码不正确")

            # p "手机号后面带空格".encode("GBK")
            # p @rs3 = @iam_obj.request_mobile_code(@tc_phone_num3)
            # assert(@rs3["code"], "使用手机号后面带空格注册用户失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
