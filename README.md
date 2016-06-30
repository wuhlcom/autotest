Window平台自动化执行环境基本配置(2016/06/08)
  1 ruby 193以上的版本及配套DevKit，当前使用ruby 2.3.0及配套DevKit
  2 gem源 http://gems.ruby-china.org
  3 gem源下载包
     3.1 page-object 1.1.0以上 当前使用page-object 1.1.1
	 3.2 watir-webdriver 0.7.0以上 当前使用0.9.1（selenum-webdriver在安装watir-webdriver时会自动安装 selenum-webdriver 2.53.0）
	 3.3 minitest 5.8.1以上 当前使用5.9.0
	 3.4 mintest-reporters 1.1.4 当前使用1.1.9
	 3.5 net-http-server 0.2.2
	 3.6 gserver 0.0.1
	 3.7 tardotgz 1.0.2
	 3.8 win32console 1.3.2
  4 本地包
     htmltags 与本svn同步到最新
	 router-page-object 与本svn同步到最新
  5 第三方工具
    Wireshark(winpcap 410,412,413均,需添加到环境变量中)
	HyenaeFE
  6 异常处理
    `出现错误:require': cannot load such file -- ffi_c (LoadError)
     ffi-1.9.10的bug
     解决方法:
     1 先删除ffi,gem uninstall ffi
     2 重新安装ffi,gem install ffi --remote --platform=ruby