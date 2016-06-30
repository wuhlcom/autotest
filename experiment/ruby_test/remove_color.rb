require 'pp'

def remove_color(str)
		str =str.strip.gsub(%r{\r|\e\[m\e\[\d+m|\e\[m|\[admin@.*\]\s*\>|\r}, "")
end

def remove_pri_color(cmd, str)
		str = str.gsub(%r{\r|\e\[m\e\[\d+m|\e\[m|\[admin@.*\]\s*\>|\r|#{cmd}}, "")
end

pptp  = "\r# nov/24/2015 20:06:17 by RouterOS 6.19\n# software id = ZJ3M-ESHW\n#\n\e[m\e[36m/interface\e[m \e[m\e[36mpptp-server\e[m \e[m\e[36mserver\n\e[m\e[35mset\e[m \e[m\e[32mauthentication\e[m\e[33m=\e[mpap\e[m\e[33m,\e[mchap\e[m\e[33m,\e[mmschap1\e[m\e[33m,\e[mmschap2 \e[m\e[32mdefault-profile\e[m\e[33m=\e[mvpn \e[m\e[32menabled\e[m\e[33m=\e[m\e[32myes\n\r\r\r\r\e[m[admin@zhilu] >                                                                \r[admin@zhilu] > "
pptp  = pptp.strip
# str =str.gsub(/\e\[m\e\[\d+m/, "")
# str =str.gsub(/\e\[m/, "")
# str = str.gsub(/\[admin@.*\]\s*\>/i,"")
# str =str.gsub(/\r/, "")
str   =pptp.gsub(%r{\r|\e\[m\e\[\d+m|\e\[m|\[admin@.*\]\s*\>|\r}, "")
# p str
# str.split("\n")

pppoe = "interface pppoe-server server pri\r[admin@zhilu] > interface pppoe-server server pri\n\rFlags: \e[m\e[1mX\e[m - disabled \n 0   \e[m\e[32mservice-name=\e[m\"pppoe\" \e[m\e[32minterface=\e[mlan \e[m\e[32mmax-mtu=\e[m1480 \e[m\e[32mmax-mru=\e[m1480 \e[m\e[32mmrru=\e[m1600 \n     \e[m\e[32mauthentication=\e[mpap,chap,mschap1,mschap2 \e[m\e[32mkeepalive-timeout=\e[m10 \n     \e[m\e[32mone-session-per-host=\e[mno \e[m\e[32mmax-sessions=\e[m0 \e[m\e[32mdefault-profile=\e[mpppoe \r\n\r\r\r\r[admin@zhilu] >                                                                \r[admin@zhilu] > "
str   =pppoe.gsub(%r{\r|\e\[m\e\[\d+m|\e\[m|\[admin@.*\]\s*\>|\r|interface pppoe-server server pri.*?}, "")
# p str = str.gsub("\n", "")
arr   = str.split(/\s+?(.+?=.+?)\s+?/)
# arr = str.split("\n")
arr.delete("")
arr.delete("\n ")
pppoe_pri={}
arr.each { |x|
		x = x.strip
		case x
				when /\s*(\d+)\s+(service-name)=\"(.+)\"/
						pppoe_pri["index"]                   =Regexp.last_match(1).strip
						pppoe_pri[Regexp.last_match(2).strip]=Regexp.last_match(3).strip
				when /(\D+.+)=(.+)/
						pppoe_pri[Regexp.last_match(1).strip]=Regexp.last_match(2).strip
		end
}
pppoe_pri


pptp_pri = "interface pptp-server server pri\r[admin@zhilu] > interface pptp-server server pri\n\r            enabled: yes\n            max-mtu: 1450\n            max-mru: 1450\n               mrru: disabled\n     authentication: pap,chap,mschap1,mschap2\n  keepalive-timeout: 30\n    default-profile: vpn\r\n\r\r\r\r[admin@zhilu] >                                                                \r[admin@zhilu] > "
cmd      = "interface pptp-server server pri"
str_new  = remove_pri_color(cmd, pptp_pri)
p arr = str_new.split("\n")
arr.delete(" ")
templet={}
arr.each { |item|

		/(?<key>.+)\s*:\s*(?<value>.+)/=~item
		templet[key.strip] =value.strip
}
p templet
