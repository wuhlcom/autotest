#encoding:utf-8
#iam api maneger api
#用户接口
#author:wuhongliang
#date:2016-07-21
file_path = File.expand_path('../pubsocket', __FILE__)
require file_path
module IAMAPI
  module User
    include IAMAPI::PubSocket
    # curl -X POST http://192.168.10.9:8092/users/adduser -d 'account=13923791162&pwd=123123&type=phone&code=1111'
    # curl -X POST http://192.168.10.9:8092/users/adduser -d 'account=349160920@126.com&pwd=123123&type=email'
    def data_register_user(phone, pw, type, code=nil, cs=0)
      data = "account=#{phone}&pwd=#{pw}&type=#{type}"
      if type=="phone"
        data = "#{data}&code=#{code}"
      elsif type=="email"
        data = "#{data}&cs=#{cs}"
      else
        fail "register type error!"
      end
      data
    end

    def register_user(account, pw, type, code=nil, cs=0, url=USER_REG_URL)
      data= data_register_user(account, pw, type, code, cs)
      rs  = post_data(url, data)
      JSON.parse(rs)
    end

    def register_phoneusr(phone, pw)
      type   ="phone"
      rs_code=request_mobile_code(phone) #请求验证码
      sleep 2
      register_user(phone, pw, type, rs_code["code"])
    end

    #cs：是否激活邮件
    #0：不激活
    #1：激活
    def register_emailusr(account, pw, cs=0)
      type = "email"
      register_user(account, pw, type, nil, cs)
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

    # curl -X POST http://192.168.10.9:8091/index.php/users/modpwd -d'name=895344033@qq.com&token=6C1GAWdn6EaYruv14z9vzE9oxLj3sUhY&password=654321'
    def data_usr_modpw_email(email, token, newpw)
      data = "name=#{email}&token=#{token}&password=#{newpw}"
    end

    # curl -X POST http://192.168.10.9:8091/index.php/users/modpwd -d'name=895344033@qq.com&token=6C1GAWdn6EaYruv14z9vzE9oxLj3sUhY&password=654321'
    def usr_modpw_email(email, token, newpw, url=USER_MODPW_EMAIL_URL)
      data = data_usr_modpw_email(email, token, newpw)
      rs   = post_data(url, data)
      JSON.parse(rs)
    end

    #找到email token-》修改密码
    def usr_find_mod_emailpw(email, newpw)
      rs = find_pwd_for_email(email)
      return rs if rs.has_key?("err_code")
      token = rs["token"]
      usr_modpw_email(email, token, newpw,)
    end

    #用户登录
    # curl -X POST http://192.168.10.9:8082/index.php/users/userlogin -d 'account=349160920@qq.com&pwd=123123&client_id=100000000000'
    # return,hash
    # {"result"=>1, "uid"=>"eb4bb4d2-e4c8-4a15-940f-91abb2ab418c", "account"=>"13760281579", "access_token"=>"b7424a90153e768068eb389a583f656f"}
    def user_login(usr, pwd, url=USER_LOGIN_URL)
      data = "account=#{usr}&pwd=#{pwd}&client_id=100000000000"
      rs   = post_data(url, data)
      JSON.parse(rs) unless rs.empty?
    end

    # 用户查询可用所有可用应用列表
    # curl -X GET "http://192.168.10.9:8092/userApps/valid?id=a7dff902-b80b-4cd7-9208-cdd856bddcd0&token=efaa91c3491d362a5d9dc3e90fa1e9ed"
    # return,hash
    #  {"totalRows"=>"1", "listRows"=>10, "nowPage"=>1,
    # "apps"=>[{"client_id"=>"160816380356", "name"=>"test_app", "provider"=>"provider", "status"=>"1", "comments"=>"oauth", "create_time"=>"1471334295", "open_id"=>""}]}
    def user_app_list_all(id, token, flag=false, url=USER_APP_LIST_URL, ip=IAM_HOST, port=IAM_PORT)
      rs = ""
      if flag
        path = "/userApps/valid?id=#{id}&token=#{token}"
        rs   =get(ip, path, port)
      else
        url = "#{url}id=#{id}&token=#{token}"
        rs  = get(url)
      end
      if rs.nil?||rs.empty?
        puts "IAM Socket bugs!Return value format error!"
        rs = false
      else
        JSON.parse(rs)
      end
    end

    #用户登录-查询可用所有可用应用列表
    def usr_login_list_app_all(usr, pwd, flag=false)
      rs   = user_login(usr, pwd)
      id   =rs["uid"]
      token=rs["access_token"]
      user_app_list_all(id, token, flag)
    end

    #用户查询可用应用列表
    # curl -X GET "http://192.168.10.9:8082/userApps/valid?id=a7dff902-b80b-4cd7-9208-cdd856bddcd0&token=efaa91c3491d362a5d9dc3e90fa1e9ed&type=name&cond=test""
    # type,string,"name","provider","comments","redirect_url"
    # return,hash
    #  {"totalRows"=>"1", "listRows"=>10, "nowPage"=>1,
    # "apps"=>[{"client_id"=>"160816380356", "name"=>"test_app", "provider"=>"provider", "status"=>"1", "comments"=>"oauth", "create_time"=>"1471334295", "open_id"=>""}]}
    # flag,ture支持中文应用名查询
    def user_app_list_bytype(cond, id, token, flag=false, type="name", url=USER_APP_LIST_URL, ip=IAM_HOST, port=IAM_PORT)
      rs = ""
      if flag
        path = "/userApps/valid?id=#{id}&token=#{token}&type=#{type}&cond=#{cond}"
        rs   =get(ip, path, port)
      else
        url = "#{url}id=#{id}&token=#{token}&type=#{type}&cond=#{cond}"
        rs  = get(url)
      end
      if rs.nil?||rs.empty?
        puts "IAM Socket bugs!Return value format error!"
        rs = false
      else
        JSON.parse(rs)
      end
    end

    #用户登录-用户查询可用应用列表
    def usr_login_list_app_bytype(usr, pwd, cond, flag, type="name")
      rs   = user_login(usr, pwd)
      id   =rs["uid"]
      token=rs["access_token"]
      user_app_list_bytype(cond, id, token, flag, type)
    end

    #用户绑定应用
    # curl -X POST "http://192.168.10.9:8091/userApps?id=a7dff902-b80b-4cd7-9208-cdd856bddcd0&token=6442491a795e6bd5d700a81b24d336f4" -d '{"client_id":"160510579648"}'
    # data = {"client_id"=>"123"} 单个绑定
    # data = {"client_id"=>"123", "client_id"=>"234"} #批量绑定
    def usr_binding_app(token, uid, data, usr_url=USER_APP_URL)
      data = data.to_json if data.kind_of?(Hash)
      url  = "#{usr_url}id=#{uid}&token=#{token}"
      rs   = post_data(url, data)
      JSON.parse(rs)
    end

    #用户解绑应用
    # curl -X DELETE "http://192.168.10.9:8091/userApps?id=a7dff902-b80b-4cd7-9208-cdd856bddcd0&token=6442491a795e6bd5d700a81b24d336f4" -d '{"client_id":"160510579648"}'
    # data = {"client_id"=>"123"} 单个解绑
    # data = {"client_id"=>"123", "client_id"=>"234"} #批量解绑
    def usr_unbinding_app(token, uid, data, usr_url=USER_APP_URL)
      data = data.to_json if data.kind_of?(Hash)
      url  = "#{usr_url}id=#{uid}&token=#{token}"
      http_del_data(url, data)
    end

    #用户登录 =》 用户解绑应用
    def login_unbinding_app(usr, pwd, data)
      rs   = user_login(usr, pwd)
      id   =rs["uid"]
      token=rs["access_token"]
      usr_unbinding_app(token, id, data)
    end

    #用户查询应用-->用户绑定应用
    # data = {"client_id"=>"123"} 单个绑定
    # data = {"client_id"=>"123", "client_id"=>"234"} #批量绑定
    def qb_app(appname, usrid, token, flag=false, type="name")
      if appname.kind_of?(Array)
        client_arr = []
        appname.each do |name|
          rs = user_app_list_bytype(name, usrid, token, flag, type)
          unless rs["apps"].empty?
            client_arr << "#{rs["apps"][0]["client_id"]}"
          else
            puts "app'#{appname}' not exists!"
            return
          end

        end
        data = "{\"client_id\":\"" + client_arr.join(",") + "\"}"
        usr_binding_app(token, usrid, data)
      else
        rs = user_app_list_bytype(appname, usrid, token, flag, type)
        unless rs["apps"].empty?
          data ={"client_id" => rs["apps"][0]["client_id"]}
          usr_binding_app(token, usrid, data)
        else
          puts "app'#{appname}' not exists!"
        end
      end
    end

    #用户登录->用户查询应用-->用户绑定应用
    def usr_qb_app(usr, pwd, appname, flag=false, type="name")
      rs_login = user_login(usr, pwd)
      usrid    =rs_login["uid"]
      token    =rs_login["access_token"]
      qb_app(appname, usrid, token, flag, type)
    end

    #用户查询应用-->用户删除绑定
    # data = {"client_id"=>"123"} 单个解除绑定
    # data = {"client_id"=>"123", "client_id"=>"234"} #批量解除绑定
    def qub_app(appname, usrid, token, flag=false, type="name")
      if appname.kind_of?(Array)
        client_arr = []
        appname.each do |name|
          rs = user_app_list_bytype(name, usrid, token, flag, type)
          unless rs["apps"].empty?
            client_arr << "#{rs["apps"][0]["client_id"]}"
          else
            puts "app'#{appname}' not exists!"
            return
          end

        end
        data = "{\"client_id\":\"" + client_arr.join(",") + "\"}"
        usr_unbinding_app(token, usrid, data)
      else
        rs = user_app_list_bytype(appname, usrid, token, flag, type)
        unless rs["apps"].empty?
          data ={"client_id" => rs["apps"][0]["client_id"]}
          usr_unbinding_app(token, usrid, data)
        else
          puts "app'#{appname}' not exists!"
        end
      end
    end

    #用户登录->用户查询应用-->用户删除绑定
    def usr_qub_app(usr, pwd, appname, flag=false, type ="name")
      rs_login = user_login(usr, pwd)
      usrid    =rs_login["uid"]
      token    =rs_login["access_token"]
      qub_app(appname, usrid, token, flag, type)
    end

    # 查看用户详细信息
    # curl -X GET "http://192.168.10.9:8091/index.php/Users/detail?admin_id=1&token=f4f2fd3697a4b9f72368081765e5be67&id=a7dff902-b80b-4cd7-9208-cdd856bddcd0"
    def get_user_details(admin_id, admin_token, uid, detail_url=USER_DETAIL_URL)
      url = "#{detail_url}admin_id=#{admin_id}&token=#{admin_token}&id=#{uid}"
      rs  = get(url)
      JSON.parse(rs)
    end

    #邮箱找回密码
    # curl -X POST http://192.168.10.9:8092/index.php/users/findPwdToken -d 'account=349160920@qq.com'
    def find_pwd_for_email(account, url=USER_FIND_PWD_URL)
      data = "account=#{account}"
      rs   = post_data(url, data)
      JSON.parse(rs) unless rs.empty?
    end

    #修改用户密码
    # curl -X POST http://192.168.10.9:8091/index.php/users/modPersonPwd -d 'oldpwd=123123&newpwd=321321&uid=123456&access_token=89aaa894cf9c8cf2c189ba8102d13d5d'
    def mofify_user_pwd(oldpwd, newpwd, uid, token, url=USER_MODPW_URL)
      data = "oldpwd=#{oldpwd}&newpwd=#{newpwd}&uid=#{uid}&access_token=#{token}"
      rs   = post_data(url, data)
      JSON.parse(rs) unless rs.empty?
    end

    #手机修改密码
    def usr_modpw_mobile_bycode(phone, pw, code, url=USER_MODPW_MOB_URL)
      data = data_usr_modpw_mobile(phone, pw, code)
      rs   = post_data(url, data)
      JSON.parse(rs)
    end

    # 'name=test&sex=1&qq=349160920&phone=13923791162&email=136@126.com&uid=123454&access_token=89aaa894cf9c8cf2c189ba8102d13d5d'
    # args为要修改的属性，例如args = {"name"=>"test", sex=>1}
    def data_usr_modify(args)
      args_arr=[]
      args.each do |key, value|
        args_arr << "#{key}=#{value}"
      end
      args_arr.join("&")
    end

    #修改用户资料
    # curl -X POST http://192.168.10.9:8091/index.php/users/profile -d 'name=test&sex=1&qq=349160920&phone=13923791162&email=136@126.com&uid=123454&access_token=89aaa894cf9c8cf2c189ba8102d13d5d'
    # 'name=test&sex=1&qq=349160920&phone=13923791162&email=136@126.com&uid=123454&access_token=89aaa894cf9c8cf2c189ba8102d13d5d'
    # args为要修改的属性，例如args = {"name"=>"test", sex=>1}
    def usr_modify(uid, token, args, url=USER_PROFILE_URL)
      data = data_usr_modify(args)+"&uid=#{uid}&access_token=#{token}"
      rs   = post_data(url, data)
      JSON.parse(rs)
    end

    #用户登录 -> 修改密码
    def usr_modify_pw_step(usr, pwd, oldpw, newpw)
      rs = user_login(usr, pwd)
      mofify_user_pwd(oldpw, newpw, rs["uid"], rs["access_token"])
    end

    #删除用户
    # curl -X POST http://192.168.10.9:8082/users/deluser -d '{"ids":"480f30b6-0f51-44e8-b3c0-d9db22557b6a,828a6550-4173-4ffa-805d-f71c4b86ec02"}'
    def delete_usr(uid, url=USER_DEL_URL)
      uids = uid
      if uid.kind_of?(Array)
        uids = uid.join(",")
      end
      data = "{\"ids\":\"" + uids + "\"}"
      rs   = post_data(url, data)
      JSON.parse(rs)
    end

    #用户登录 =》 删除用户
    def usr_delete_usr(usr, pwd, url=USER_DEL_URL)
      rs_login = user_login(usr, pwd)
      if rs_login.has_key?("err_code")
        puts "user '#{usr}' login failed,err_desc:#{rs_login["err_desc"]}"
      else
        uid =rs_login["uid"]
        delete_usr(uid, url)
      end

    end
  end
end