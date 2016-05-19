#encoding:utf-8
require 'cgi'
p "我"
p url_encoded_string = CGI::escape("我")
p url_encoded_string = CGI::unescape("我")
p url_encoded_string = CGI::escape("1234578")
p url_encoded_string = CGI::escape("'Stop!' said Fred")


str = "\r# nov/24/2015 19:32:17 by RouterOS 6.19\n# software id = ZJ3M-ESHW\n#\n\e[m\e[36m/interface\e[m \e[m\
mserver\n\e[m\e[35mset\e[m \e[m\e[32mauthentication\e[m\e[33m=\e[mpap\e[m\e[33m,\e[mchap\e[m\e[33m,\e[mmschap1\e[m\e[33m
-profile\e[m\e[33m=\e[mvpn \e[m\e[32menabled\e[m\e[33m=\e[m\e[32myes\n\r\r\r\r\e[m[admin@zhilu] >
           \r[admin@zhilu] > "
p url_encoded_string = CGI::unescape(str)
p url_encoded_string = CGI::escape(str)