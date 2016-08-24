#encoding:utf-8
#iam api maneger api
#管理员接口
#author:wuhongliang
#date:2016-07-21
file_path = File.expand_path('../pubsocket', __FILE__)
require file_path
module IAMAPI
    module User
        include IAMAPI::PubSocket
        # curl -X POST http://192.168.10.9:8092/users/adduser -d 'account=13923791162&pwd=123123&type=phone&code=1111'
        # curl -X POST http://192.168.10.9:8092/users/adduser -d 'account=349160920@126.com&pwd=123123&type=email'
        def data_register_user(phone, pw, type, code=nil)
            data = "account=#{phone}&pwd=#{pw}&type=#{type}"
            if type=="phone"
                data = "#{data}&code=#{code}"
            elsif type=="email"
                data
            else
                fail "register type error!"
            end
            data
        end

        def register_user(phone, pw, type, code=nil, url=USER_REG_URL)
            data=data_register_user(phone, pw, type, code)
            rs  = post_data(url, data)
            JSON.parse(rs)
        end

        def register_phoneusr(phone, pw)
            type   ="phone"
            rs_code=request_mobile_code(phone) #请求验证码
            sleep 2
            register_user(phone, pw, type, rs_code["code"])
        end


        # curl -X POST http://192.168.10.9:8092/index.php/users/modpwdByMobile -d 'account=13923791162&password=123123&code=1234'
        def data_usr_modpw_mobile(phone, pw, code)
            data = "account=#{phone}&password=#{pw}&code=#{code}"
        end

        #获取验证码->修改密码
        def usr_modpw_mobile(phone, pw, url=USER_MODPW_MOB_URL)
            rs_code = request_mobile_code(phone)
            data    = data_usr_modpw_mobile(phone, pw, rs_code["code"])
            rs      = post_data(url, data)
            JSON.parse(rs)
        end

    end
end