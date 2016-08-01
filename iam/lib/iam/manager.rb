#encoding:utf-8
#iam api maneger api
#管理员接口
#author:wuhongliang
#date:2016-07-21
file_path = File.expand_path('../pubsocket', __FILE__)
require file_path
module IAMAPI
    module Manager
        include IAMAPI::PubSocket
        # {
        #     "result":1,
        #     "name":"admin@zhilutec.com",
        #     "nickname":"\u552f\u4e00\u77e5\u8def\u8d85\u7ea7\u7ba1\u7406\u5458",
        #     "uid":"1",
        #     "role_code":"1",
        #     "token":"34d5aeb4b075ef65f6aa156f202127e4"
        # }
        # {
        #     "err_code": 10006,
        #     "err_msg": "帐号或密码错误"
        # }
        # curl -X POST http://192.168.10.9:8092/admins/dologin -d 'name=admin@zhilutec.com&password=123123'
        def data_manager_login(usr, pw)
            data = "name=#{usr}&password=#{pw}"
        end

        # result:
        #   {
        #   "result"=>1,
        #   "name"=>"admin@zhilutec.com",
        #   "nickname"=>"\u77E5\u8DEF\u7BA1\u7406\u5458",
        #   "uid"=>"1",
        #   "role_code"=>"1", "
        #   token"=>"ef75b14c2fe47c09b2f3def7e53d1f32"
        #   }
        #返回管理员uid和token
        def manager_login(usr="admin@zhilutec.com", pw="123123", url=MANAGER_LOG_URL)
            data       = data_manager_login(usr, pw)
            rs         = post_data(url, data)
            admin_hash = JSON.parse(rs)
        end

        #curl -X POST http://192.168.10.9:8082/index.php/admins/add/uid/1/token/34d5aeb4b075ef65f6aa156f202127e4
        # -d 'account=chaoji@126.com&nickname=test_nickname&password=123123&role_code=2&comments=ttttttt&pid=1'
        def url_manager_add(token, uid=1)
            url = "http://192.168.10.9:8082/index.php/admins/add/uid/#{uid}/token/#{token}"
        end

        def data_manager_add(account, nickname, passwd, rcode="2", commnets="autotest", pid=1)
            data = "account=#{account}&nickname=#{nickname}&password=#{passwd}&role_code=#{rcode}&comments=#{commnets}&pid=#{pid}"
        end

        def mana_add(token, account, nickname, passwd, rcode="2", commnets="autotest", uid=1, pid=1)
            url  = url_manager_add(token, uid)
            data = data_manager_add(account, nickname, passwd, rcode, commnets, pid)
            rs   = post_data(url, data)
            JSON.parse(rs)
        end

        #rcode,2-超级管理员，3-系统管理员,4-配置管理员，5-监视管理员
        #return,hash
        def manager_add(account, nickname, passwd, rcode="2", commnets="autotest", pid=1, uid=1)
            rs_login = manager_login
            token    = rs_login["token"]
            mana_add(token, account, nickname, passwd, rcode, commnets, uid, pid)
        end

        #如果管理员存在删除后重新添加，如果不存在则直接添加
        #查询账户是否存在-存的话先删除再添加账户，不存在直接添加
        def manager_del_add(account, passwd, nickname, rcode="2", commnets="autotest", pid=1, uid=1)
            rs_admin = manager_login
            token    = rs_admin["token"]
            rs_mlist = get_manager_list_byname(account, token)
            if rs_mlist["res"].empty?
                mana_add(token, account, nickname, passwd, rcode, commnets, uid, pid)
            else
                userid = rs_mlist["res"][0]["id"]
                delete_manager(userid, token)
                mana_add(token, account, nickname, passwd, rcode, commnets, uid, pid)
            end
        end

        #查询管理员信息
        #显示所有
        # curl -X GET http://192.168.10.9:8082/index.php/admins/index/uid/1/token/34d5aeb4b075ef65f6aa156f202127e4
        #分页显示
        # curl -X GET http://192.168.10.9:8082/index.php/admins/index/uid/1/p/2/token/34d5aeb4b075ef65f6aa156f202127e4
        #按用户名查找
        # curl -X GET http://192.168.10.9:8092/index.php/admins/index/uid/1/name/dengfei/token/34d5aeb4b075ef65f6aa156f202127e4
        def get_manager_list_all(token)
            url = "http://192.168.10.9:8082/index.php/admins/index/uid/1/token/#{token}"
            rs  = get(url)
            JSON.parse(rs)
        end

        def get_manager_list_byname(account, token)
            url = "http://192.168.10.9:8082/index.php/admins/index/uid/1/name/#{account}/token/#{token}"
            rs  =get(url)
            JSON.parse(rs)
        end

        #返回结果为hash,name是支持模糊匹配的
        # {"totalRows"=>"1", "listRows"=>10, "nowPage"=>1,
        # "res"=>[{"id"=>"11", "name"=>"whltest2@zhilutec.com", "nickname"=>"whltest2",
        # "comments"=>"autotest", "title"=>"\u8D85\u7EA7\u7BA1\u7406\u5458"}]}
        def get_mlist_byname(account)
            rs = manager_login
            get_manager_list_byname(account, rs["token"])
        end

        def get_mlist_all
            rs = manager_login
            get_manager_list_all(rs["token"])
        end

        #删除管理员
        # curl -X GET http://192.168.10.9:8082/index.php/admins/del/uid/1/userid/123/token/f4f2fd3697a4b9f72368081765e5be67
        # 知路管理员admin@zhilutec.com的token和uid
        def delete_manager(userid, token, uid="1")
            url = "http://192.168.10.9:8082/index.php/admins/del/uid/#{uid}/userid/#{userid}/token/#{token}"
            get(url)
        end

        #name必须用完整管理员名
        def del_manager(name, uid="1")
            rs_del   = {}
            rs_login = manager_login
            rs       = get_manager_list_byname(name, rs_login["token"])
            if rs["res"].empty?
                puts "#{name} is not exists!"
            else
                userid = rs["res"][0]["id"]
                rs_del = delete_manager(userid, rs_login["token"], uid)
                rs_del = JSON.parse(rs_del)
            end
            return rs_del
        end


        # 手机管理员密码修改
        # curl -X POST http://192.168.10.9:8091/index.php/Admins/modpwdByMobile -d 'name=13923791162&password=123123&code=1234'
        def data_manager_modpw_mobile(phone, pw, code)
            data = "name=#{phone}&password=#{pw}&code=#{code}"
        end

        def phone_manager_modpw(phone, pw, code, url=MANAGER_MODPW_MOB_URL)
            data =data_manager_modpw_mobile(phone, pw, code)
            rs   = post_data(url, data)
            JSON.parse(rs)
        end

        #获取手机管理员验证码->修改密码
        def manager_modpw_mobile(phone, pw, url=MANAGER_MODPW_MOB_URL)
            fail "phone number must be 11 size" if phone.to_s.size != 11
            rs_code = request_mobile_code(phone)
            phone_manager_modpw(phone, pw, rs_code["code"], url)
        end

        #手管理员不存在则添加管理员并修改密码，管理存在，直接修改密码
        #phone必须是有效的号码段手机号如134X，158X,如果是251X会失败
        def mobile_manager_modpw(phone, mod_pw, add_pw="123456", nickname="autotest", url=MANAGER_MODPW_MOB_URL)
            fail "phone number must be 11 size" if phone.to_s.size != 11
            rs_login = manager_login #超级管理登录
            token    = rs_login["token"]
            rs_mlist = get_manager_list_byname(phone, token)
            if rs_mlist["res"].empty? #如果管理员不存在则先添加管理员
                puts "add phone manager #{phone}"
                rs_mana = mana_add(token, phone, nickname, add_pw)
                if rs_mana["result"]==1
                    puts "mode phone manager #{phone} pw"
                    rs = manager_modpw_mobile(phone, mod_pw, url)
                else
                    rs={"err_msg" => "add manager failed"}
                end
            else #管理员存在直接修改管理员密码
                puts "mode phone manager #{phone} pw"
                rs = manager_modpw_mobile(phone, mod_pw, url)
            end
            return rs
        end

        # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=f816eabf9964b995313948a0d6c4c085" // 查询全部
        # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=XXXX&listRows=2&p=2" // 分页查询
        # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=XXXX&type=name&cond=123" // 模糊查询
        #args
        # 1: {"listRows"=>"2","p"=>"2"}
        # 2: {"type"=>"name","cond"=>"IAM"}
        #    type。模糊查询类型，name:应用名称 id:应用编号 provider:应用提供方
        #    cond, 模糊查询条件。为空则不进行模糊查询，type,cond条件无效则查询全部
        #return,String
        #  "http://192.168.10.9:8082/apps?admin_id=1&token=f816eabf9964b995313948a0d6c4c085" // 查询全部
        #  "http://192.168.10.9:8082/apps?admin_id=1&token=XXXX&listRows=2&p=2" // 分页查询
        #  "http://192.168.10.9:8082/apps?admin_id=1&token=XXXX&type=name&cond=123" // 模糊查询
        def data_app_list(token, uid="1", args =nil)
            data    =""
            args_arr=[]
            if args.nil?
                data = "admin_id=#{uid}&token=#{token}"
            elsif args.kind_of?(Hash)
                data = "admin_id=#{uid}&token=#{token}&"
                args.each do |key, value|
                    args_arr<<"#{key}=#{value}"
                end
                data=data+args_arr.join("&")
            else
                "params error!"
            end
            return data
        end

        #return,Hash，返回应用列表信息
        # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=f816eabf9964b995313948a0d6c4c085" // 查询全部
        # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=XXXX&listRows=2&p=2" // 分页查询
        # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=XXXX&type=name&cond=123" // 模糊查询
        def get_app_list(token, uid="1", args =nil, url=APP_URL)
            uri = uri(url+data_app_list(token, uid, args))
            rs  = get(uri)
            JSON.parse(rs)
        end

        #return,Array，获取应用列表中应用信息
        def get_app_info(token, uid="1", args =nil, url=APP_URL)
            rs = get_app_list(token, uid, args, url)
            rs["apps"]
        end

        #return,Hash，获取应用列表中指定应用信息
        def get_spec_app_info(token, appname, uid="1", args =nil, url=APP_URL)
            app_info={}
            rs      = get_app_info(token, uid, args, url)
            rs.each do |app|
                if app.has_value?(appname)
                    app_info=app
                end
            end
            return app_info
        end

        #创建应用
        # curl -X POST "http://192.168.10.9:8082/apps?admin_id=1&token=f816eabf9964b995313948a0d6c4c085" -d '{"name":"test", "provider":"知路公司","redirect_uri":"http://www.test.com"}'
        # args = "{\"name\":\"#{name}\", \"provider\":\"#{provider}\",\"redirect_uri\":\"#{redirect_uri}\",\"comments\":\"#{comments}\"}"
        def create_apply(admin_id, token, args, app_url=APP_URL)
            url = "#{app_url}admin_id=#{admin_id}&token=#{token}"
            rs  = post_data(url, args)
            JSON.parse(rs)
        end

        # 返回应用ID
        def get_client_id(apply_name, token, uid, args=nil, url=APP_URL)
            if apply_name.kind_of?(Array)
                client_id_arr = []
                apply_name.each do |apply|
                    res = get_spec_app_info(token, apply, uid, args, url)
                    client_id_arr << res["client_id"]
                end
                client_id_arr.join(",")
            else
                res = get_spec_app_info(token, apply_name, uid, args, url)
                res["client_id"]
            end
        end

        #删除指定应用
        # curl -X DELETE "http://192.168.10.9:8082/apps?id=160517254512&admin_id=1&token=125e0d6b0cf379e4d51fbf47bdd9598c"
        # curl -X DELETE "http://192.168.10.9:8091/apps?id=1111,2222,3333&admin_id=1" // 批量删除
        #appname = "autotest1"
        #appname = ["autotest1", "autotest2"]
        def del_apply(appname, token, uid, args =nil, url=APP_URL)
            client_id = get_client_id(appname, token, uid, args, url) #应用ID
            path      = "#{url}id=#{client_id}&admin_id=#{uid}&token=#{token}"
            rs        = http_del(path)
            JSON.parse(rs)
        end

        #查看应用详情
        # curl -X GET "http://192.168.10.9:8091/apps?id=160512231520&admin_id=1&token=34d5aeb4b075ef65f6aa156f202127e4"
        def apply_details(client_id, admin_id, token, app_url=APP_URL)
            url = "#{app_url}id=#{client_id}&admin_id=#{admin_id}&token=#{token}"
            rs  = http_get(url)
            JSON.parse(rs)
        end

        #修改应用
        #curl -X PUT "http://192.168.10.9:8091/apps?admin_id=1&token=34d5aeb4b075ef65f6aa156f202127e4&id=160512231520" -d '{"name":"test_put","provider":"zhilu","redirect_uri":"http://www.zhilutec.com","comments":""}'
        # args = "{\"name\":\"#{name}\",\"provider\":\"#{provider}\",\"redirect_uri\":\"#{re_uri}\",\"comments\":\"#{comments}\"}"
        def modify_apply(admin_id, token, client_id, args, app_url=APP_URL)
            url = "#{app_url}admin_id=#{admin_id}&token=#{token}&id=#{client_id}"
            rs  = http_put(url, args)
            JSON.parse(rs)
        end

    end
end