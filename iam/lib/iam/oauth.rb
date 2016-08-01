#encoding:utf-8
#iam api,user oauth api
#用户oauth接口

#author:wuhongliang
#date:2016-07-21
file_path =File.expand_path('../pubsocket', __FILE__)
require file_path
module IAMAPI
    module Oauth
        include IAMAPI::PubSocket
        #user login data
        # curl http://192.168.10.9:8092/index.php/Oauth/authorize -d
        # "username=18986681621
        # &encrypt_pwd=9b44e764fb94a12bd799b761ea7db865cb4ab6cbce9a72c8251fcdfcbbe626d7a9fc02a50f124ae3f133ad9aaf4455884f0462b20cd251ebd09298dc1920305a3ed90a242813bd4f8a6c55f9d65072ed6eac723292d6327b9fa0f907ce735d1fbe6ea919010b504b5111ec962cf63299a660a4febdafa9856a7c55c6b70604fe
        # &redirect_uri=http://192.168.10.9/oauthcli/index.php/Login/index
        # &secret=qItiMyKZJtJcggm9YSnqwhMj8li8hJe7 #应用秘钥
        # &response_type=code
        # &client_id=160518183738" #应用ID
        #return,String
        # oauth_url   = "http://192.168.10.9:8082/index.php/Oauth/authorize"
        # username    = "13760281579" #注册用户名
        # encrypt_pwd = "9c76736d8a993299e155c797861d14ef7cd3507c900527e11da5d3357872ba9fb9e2db9511fe2bfafe7a6d4c6f8efdac40425414639e4815069c380c86ef4a7dd121e7db0418919a3ca8de77d745269ad19ea117154411df35f840eb1af5e82383c2d6dc627b3654f15596959e1643707995e9ef3db2847c0ca60de50ac43fc0" #用户密码
        # clientid    = rs_app["client_id"]
        # secret      = rs_app["client_secret"]
        def data_user_login(username, encrypt_pwd, secret, client_id, response_type="code", redirect_uri=REDIRECT_URL)
            data = " username= #{username}&encrypt_pwd=#{encrypt_pwd}&redirect_uri=#{redirect_uri}&secret=#{secret}&response_type=#{response_type}&client_id=#{client_id}"
        end

        # user login
        # oauth_url   = "http://192.168.10.9:8082/index.php/Oauth/authorize"
        # username    = "13760281579" #注册用户名
        # encrypt_pwd = "9c76736d8a993299e155c797861d14ef7cd3507c900527e11da5d3357872ba9fb9e2db9511fe2bfafe7a6d4c6f8efdac40425414639e4815069c380c86ef4a7dd121e7db0418919a3ca8de77d745269ad19ea117154411df35f840eb1af5e82383c2d6dc627b3654f15596959e1643707995e9ef3db2847c0ca60de50ac43fc0" #用户密码
        # clientid    = rs_app["client_id"]
        # secret      = rs_app["client_secret"]
        def user_login(username, encrypt_pwd, secret, client_id, url=OAUTH_URL, response_type="code")
            data = data_user_login(username, encrypt_pwd, secret, client_id, response_type)
            post_data(url, data)
        end

        #解析用户oauth,返回用户id
        def parse_user_oauth(html)
            user_id = ""
            doc     = doc(html)
            doc.css("form input").each do |input|
                name_attr = input.attributes["name"]
                next if name_attr.nil?
                name_cont = name_attr.content
                if name_cont=="user_id"
                    user_id = input.attributes["value"].content
                end
            end
            user_id
        end

        #用户oauth接入调用->解析用户oauth,返回用户id
        def user_oauth(username, encrypt_pwd, secret, client_id, url=OAUTH_URL, response_type="code")
            html = user_login(username, encrypt_pwd, secret, client_id, url, response_type)
            parse_user_oauth(html)
        end

        #获取code
        #curl 192.168.10.9:8082/index.php/Oauth/finishAuthorization -d
        # "user_id=917a204d-f2cb-4255-bc92-8cf969f2798b&client_id=160603714647 #用户id，应用id
        # &redirect_uri=http://192.168.10.9:8083/index.php/Login/index
        # &secret=zJsqR9XiRaJQzDjpxxpqgS3FAq0Equkp&response_type=code" #应用密钥和类型
        def data_code(user_id, client_id, secret, response_type="code", redirect_uri=REDIRECT_URL)
            data = "user_id=#{user_id}&client_id=#{client_id}&redirect_uri=#{redirect_uri}&secret=#{secret}&response_type=#{response_type}"
        end

        #user_id,用户ID
        #client_id,应用ID
        #secret,应用密钥
        #response_type,应用类型
        #url,获取code的URL
        #重定向url
        def get_code(user_id, client_id, secret, response_type="code", url=OAUTH_F_URL)
            data = data_code(user_id, client_id, secret, response_type)
            post_data(url, data)
        end

    end
end
