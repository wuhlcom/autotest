#encoding:utf-8
require 'pp'
require 'net/http'
require 'uri'
require 'nokogiri'
require 'json'
module IAMAPI
    # url      = "http://192.168.10.9:8082/user.txt"
    def uri(url)
        uri = URI(url)
    end

    def get(url)
        uri =uri(url)
        Net::HTTP.get(uri) # => String
    end

    #
    def doc(html)
        doc = Nokogiri::HTML(html)
    end

    #=================================
    # http.request_post(uri, data)
    #=============================
    # http.request_post(uri, str) { |response|
    #     response['content-type']
    #     p response.code_type
    #     response.read_body do |str| # read body now
    #         str
    #     end
    # }
    #=================================
    #
    def post_data(url, data)
        uri =uri(url)
        res = Net::HTTP.start(uri.hostname, uri.port) do |http|
            http.request_post(uri, data)
        end
        res.body
    end

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
    def data_admin_login(usr, pw)
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
    def admin_login(url, usr="admin@zhilutec.com", pw="123123")
        uri        = uri(url)
        data       = data_admin_login(usr, pw)
        rs         = post_data(uri, data)
        admin_hash = JSON.parse(rs)
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
    def get_app_list(url, token, uid="1", args =nil)
        uri = uri(url+data_app_list(token, uid, args))
        rs  = get(uri)
        JSON.parse(rs)
    end

    #return,Array，获取应用列表中应用信息
    def get_app_info(url, token, uid="1", args =nil)
        rs = get_app_list(url, token, uid, args)
        rs["apps"]
    end

    #return,Hash，获取应用列表中指定应用信息
    def get_spec_app_info(url, token, appname, uid="1", args =nil)
        app_info={}
        rs      = get_app_info(url, token, uid, args)
        rs.each do |app|
            if app.has_value?(appname)
                app_info=app
            end
        end
        return app_info
    end

    # user login
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
    def data_user_login(username, encrypt_pwd, secret, client_id, response_type="code", redirect_uri="http://192.168.10.9:8083/oauthcli/index.php/Login/index")
        data = "username=#{username}&encrypt_pwd=#{encrypt_pwd}&redirect_uri=#{redirect_uri}&secret=#{secret}&response_type=#{response_type}&client_id=#{client_id}"
    end

    # oauth_url   = "http://192.168.10.9:8082/index.php/Oauth/authorize"
    # username    = "13760281579" #注册用户名
    # encrypt_pwd = "9c76736d8a993299e155c797861d14ef7cd3507c900527e11da5d3357872ba9fb9e2db9511fe2bfafe7a6d4c6f8efdac40425414639e4815069c380c86ef4a7dd121e7db0418919a3ca8de77d745269ad19ea117154411df35f840eb1af5e82383c2d6dc627b3654f15596959e1643707995e9ef3db2847c0ca60de50ac43fc0" #用户密码
    # clientid    = rs_app["client_id"]
    # secret      = rs_app["client_secret"]
    def user_login(url, username, encrypt_pwd, secret, client_id)
        data = data_user_login(username, encrypt_pwd, secret, client_id)
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
    def user_oauth(url, username, encrypt_pwd, secret, client_id)
        html = user_login(url, username, encrypt_pwd, secret, client_id)
        parse_user_oauth(html)
    end

    #get userid
    def check_userid(url="http://192.168.10.9:8082/userid.txt")
        get(url)
    end
end

if __FILE__==$0
    include IAMAPI
    admin_url = "http://192.168.10.9:8082/admins/dologin"
    rs        = admin_login(admin_url) #管理员登录->得到uid和token
    # {"result"=>1, "name"=>"admin@zhilutec.com", "nickname"=>"\u77E5\u8DEF\u7BA1\u7406\u5458", "uid"=>"1", "role_code"=>"1", "token"=>"c7dd9954c18fdbcb65e9fb35638e9025"}
    app_url   = "http://192.168.10.9:8082/apps?"
    rs["nickname"].encode("GBK")
    appname = "IAMAPI_IAM_F_OAuth_019"
    args    = {"type" => "name", "cond" => "IAMAPI_IAM_F_OAuth_019"}
    rs_app  = get_spec_app_info(app_url, rs["token"], appname, rs["uid"]) #获取指定应用ID和密钥->输入uid和token，得到secret和client_id

    oauth_url   = "http://192.168.10.9:8082/index.php/Oauth/authorize"
    username    = "13760281579" #注册用户名
    encrypt_pwd = "9c76736d8a993299e155c797861d14ef7cd3507c900527e11da5d3357872ba9fb9e2db9511fe2bfafe7a6d4c6f8efdac40425414639e4815069c380c86ef4a7dd121e7db0418919a3ca8de77d745269ad19ea117154411df35f840eb1af5e82383c2d6dc627b3654f15596959e1643707995e9ef3db2847c0ca60de50ac43fc0" #用户密码
    client_id   = rs_app["client_id"]
    secret      = rs_app["client_secret"]
    # print user_login(oauth_url, username, encrypt_pwd, secret, clientid) #用户oauth登录
    user_oauth(oauth_url, username, encrypt_pwd, secret, client_id) ##用户oauth登录,输入secret和client_id得到用户的userid
    check_url = "http://192.168.10.9:8082/userid.txt"
    check_userid(check_url) #获取userid
end

