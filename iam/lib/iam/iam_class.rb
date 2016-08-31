#encoding:utf-8
#iam api maneger api
#管理员接口
#author:wuhongliang
#date:2016-07-21
file_path1 = File.expand_path('../manager', __FILE__)
file_path2 = File.expand_path('../oauth', __FILE__)
file_path3 = File.expand_path('../user', __FILE__)
file_path4 = File.expand_path('../device', __FILE__)
file_path5 = File.expand_path('../js_encry', __FILE__)
file_path5 = File.expand_path('../device', __FILE__)
require file_path1
require file_path2
require file_path3
require file_path4
require file_path5
module IAMAPI
  class IAM
    include IAMAPI::Manager
    include IAMAPI::Oauth
    include IAMAPI::User
    include IAMAPI::Device

    #用户登录 =》添加设备
    def usr_add_devices(dev_name, dev_mac, usr, pw)
      rs  = user_login(usr, pw)
      uid = rs["uid"]
      add_device(dev_name, dev_mac, uid)
    end

    #用户登录 =》 查询设备id-》删除设备
    def usr_delete_device(dev_name, usr, pw, args=nil)
      rs  = user_login(usr, pw)
      uid = rs["uid"]
      qd_dev(dev_name, uid, args=nil)
    end

    #用户登录 =》 设备关联应用
    def usr_dev_bindapp(dev_name, cli_arr, usr, pw, args=nil)
      rs  = user_login(usr, pw)
      uid = rs["uid"]
      qb_dev(dev_name, uid, cli_arr, args)
    end

    #用户登录 =》 查看设备列表
    def usr_get_devlist(usr, pw, args =nil, flag=false)
      rs  = user_login(usr, pw)
      uid = rs["uid"]
      get_dev_list(uid, args, flag)
    end

    #查询用户，如果用户不存在则注册用户
    #args,hash,{"type"=>"account","cond"=>"xxx"}
    #args={"type"=>"account","cond"=>"13712341234"}
    def phone_usr_reg(phone, pw, args, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs     = manager_login(admin_usr, admin_pw)
      uid    =rs["uid"]
      token  = rs["token"]
      rs_usr = get_user_list(uid, token, args)
      if rs_usr["users"].empty?
        register_phoneusr(phone, pw)
      else
        puts "User '#{phone}' existed!"
      end
    end
    
    #args,hash,{"type"=>"account","cond"=>"xxx"}
    #args={"type"=>"account","cond"=>"13712341234"}
    #cs=0,不激活，cs=1激活邮箱
    def email_usr_reg(email, pw, args, cs=1, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs     = manager_login(admin_usr, admin_pw)
      uid    =rs["uid"]
      token  = rs["token"]
      rs_usr = get_user_list(uid, token, args)
      if rs_usr["users"].empty?
        register_emailusr(email, pw, cs)
      else
        puts "User '#{email}' existed!"
      end
    end

    #获取应用id->查询应用进程
    def get_app_files(apply_name, token, uid, args=nil)
      id = get_client_id(apply_name, token, uid, args)
      get_app_file(id)
    end

    #管理员登录-获取应用id->查询应用进程
    def mana_get_app_files(apply_name, args=nil, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs    = manager_login(admin_usr, admin_pw)
      uid   = rs["uid"]
      token = rs["token"]
      id    = get_client_id(apply_name, token, uid, args)
      get_app_file(id)
    end

    ##用户登录 =》 编辑设备
    def usr_device_editor(usr, pw, device_name, editor_name, args=nil)
      rs        = user_login(usr, pw)
      uid       = rs["uid"]
      device_id = get_dev_id_for_name(device_name, uid, args)
      device_editor(uid, device_id, editor_name)
    end

  end

end