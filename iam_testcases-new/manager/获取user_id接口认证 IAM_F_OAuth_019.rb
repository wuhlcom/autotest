#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_OAuth_019", "level" => "P1", "auto" => "n"}

    def prepare

    end

    def process

        operate("1、ssh登录到IAM服务器；") {
        }

        operate("2、用户登录；") {
            rs  = @iam_obj.oauth_get_userid
            rs2 = @iam_obj.get(@ts_url_userid)
            assert_equal(rs2, rs, "用户id获取失败")
        }


    end

    def clearup
        operate("1.恢复默认设置") {

        }
    end

}
