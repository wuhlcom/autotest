---
##目录说明:
1. **autotest_sdk**     SDK自动化测试的全套脚本
2. **frame_test**       测试和调试自动化框架
3. **htmltags**     自动化基础支撑:windows系统接口，有线无线网卡操作，路由器登录，Minitest,Reporter,RouterOS操作,抓包操作,FTP操作等
4. **router_page_obect**        自动化WEB PageObject封装：统一平台WEB TAG及操作步骤封装
5. **services**     提供Druby分布式服务，HTTP，TCP,UDP,FTP等服务
6. **iam**      IAM API接口封装，oauth js加密封装
7. **iam_testcases**        IAM API接口测试脚本
8. **tools**        自动化一些工具，脚本模板生成，excel生成与解析，xml生成与解析等
9. **experiment**	        一些ruby库，ruby gem的实验与使用
10. **js加密**        oauth js加密WEB版本
---  
##Window平台自动化执行环境基本配置(2016/06/08)
1. **ruby 193以上的版本及配套DevKit，当前使用ruby 2.3.0及配套DevKit**
2. **gem源 http://gems.ruby-china.org**
3. **gem源下载包**
  
     3.1 page-object 1.1.0以上 当前使用page-object 1.1.1
     
	 3.2 watir-webdriver 0.7.0以上 当前使用0.9.1（selenum-webdriver在安装watir-webdriver时会自动安装 selenum-webdriver 2.53.0）
	 
	 3.3 minitest 5.8.1以上 当前使用5.9.0
	 
	 3.4 mintest-reporters 1.1.4 当前使用1.1.9
	 
	 3.5 net-http-server 0.2.2
	 
	 3.6 gserver 0.0.1
	 
	 3.7 tardotgz 1.0.2
	 
	 3.8 win32console 1.3.2
	 
4. **本地包**  
     htmltags 与svn同步到最新     
	 router-page-object 与svn同步到最新
	 
5. **第三方工具**  
    Wireshark(winpcap 410,412,413均可,需将Wireshark.exe目录添加到环境变量中)    
    HyenaeFE	
6. **异常处理**  
出现错误:require: cannot load such file -- ffi_c (LoadError)    
 ffi-1.9.10的bug     
 解决方法:    
  1 先删除ffi,gem uninstall ffi    
  2 重新安装ffi,gem install ffi --remote --platform=ruby
     
7. **设备IP**   
**环境1**                
执行机:control 50.50.50.55, dut->dhcp,ap->192.168.50.x       
业务PC:control 50.50.50.56,wireless			
继电器:50.50.50.101

   **环境2**  
执行机:control 50.50.50.50, dut->dhcp,ap->192.168.50.x    
业务PC:control 50.50.50.51	
继电器:50.50.50.110

   **公共环境**
	
   **服务器：**
	
lan配置静态IP但不配置网关50.50.50.57,10.10.10.57，	
配置静态路由20.20.20.x和30.30.30.x,网关为10.10.10.1 	
wan 配置静态IP,虚拟机开启RouteOS	
交换机：50.50.50.100,wireless	
FileZilla Server作为FTP服务器	
SVN服务器可用于多人开发时同步代码，快速部署环境，备份代码

8. **环境服务开启**

断电后或重启后，手动开启的服务     
50.50.50.57    StartServices.bat,这个批处理会开启Druby,http,tcp,udp四个服务     
50.5.50.51/56  Druby_server.bat开启Druby	 
VMware中的RouterOS服务:打开VMware->Autotest MiroTik RouterOS618将此虚拟机开启	 
自动开启的服务	 
ftp,svn默认自动开启，如果发现自动开启失败就需要手动开启
