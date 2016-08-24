# `tshark -ni local -Y "udp" -T fields -a duration:5 -e frame.number -e frame.time -e ip.src -e ip.dst`
fields = '-e "frame.number" -e "eth.dst" -e "eth.src"  -e "ip.src" -e "ip.dst" -e "bootp.option.type" -e "bootp.option.ip_address_lease_time"'
# print `tshark -ni "dut" -Y "bootp.option.type==51" -T fields -a "duration:80" -e "frame.number" -e "eth.dst" -e "eth.src"  -e "ip.src" -e "ip.dst" -e "bootp.option.type" -e "bootp.option.ip_address_lease_time"`
print `tshark -ni "dut" -Y "bootp.option.type==51" -T fields -a "duration:80" #{fields}`
# print `tshark -ni "dut" -Y "bootp.option.type==51" -T text -a duration:10`

#acket Details Markup Language, an XML-based format for the details of a decoded packet. This information is equivalent to the packet details printed with the -V flag.
#xml格式报文
# <?xml version="1.0"?>
# 		<?xml-stylesheet type="text/xsl" href="pdml2html.xsl"?>
# 		<!-- You can find pdml2html.xsl in C:\Program Files (x86)\Wireshark or at http://anonsvn.wireshark.org/trunk/wireshark/pdml2html.xsl. -->
# <pdml version="0" creator="wireshark/1.12.7" time="Fri Sep 18 14:24:41 2015" capture_file="">
# <packet>
# <proto name="geninfo" pos="0" showname="General information" size="74">
# <field name="num" pos="0" show="1" showname="Number" value="1" size="74"/>
# <field name="len" pos="0" show="74" showname="Frame Length" value="4a" size="74"/>
# <field name="caplen" pos="0" show="74" showname="Captured Length" value="4a" size="74"/>
# <field name="timestamp" pos="0" show="Sep 18, 2015 14:24:42.330338000 涓浗鏍囧噯鏃堕棿" showname="Captured Time" value="1442557482.330338000" size="74"/>
# </proto>
#   <proto name="frame" showname="Frame 1: 74 bytes on wire (592 bits), 74 bytes captured (592 bits) on interface 0" size="74" pos="0">
#     <field name="frame.interface_id" showname="Interface id: 0 (\Device\NPF_{ACCA7C5A-4CDD-43C6-8CCF-631228DCB498})" size="0" pos="0" show="0"/>
# <field name="frame.encap_type" showname="Encapsulation type: Ethernet (1)" size="0" pos="0" show="1"/>
# <field name="frame.time" showname="Arrival Time: Sep 18, 2015 14:24:42.330338000 \xe4\xb8\xad\xe5\x9b\xbd\xe6\xa0\x87\xe5\x87\x86\xe6\x97\xb6\xe9\x97\xb4" size="0" pos="0" show="Sep 18, 2015 14:24:42.330338000 \xe4\xb8\xad\xe5\x9b\xbd\xe6\xa0\x87\xe5\x87\x86\xe6\x97\xb6\xe9\x97\xb4"/>
# <field name="frame.offset_shift" showname="Time shift for this packet: 0.000000000 seconds" size="0" pos="0" show="0.000000000"/>
# <field name="frame.time_epoch" showname="Epoch Time: 1442557482.330338000 seconds" size="0" pos="0" show="1442557482.330338000"/>
# <field name="frame.time_delta" showname="Time delta from previous captured frame: 0.000000000 seconds" size="0" pos="0" show="0.000000000"/>
# <field name="frame.time_delta_displayed" showname="Time delta from previous displayed frame: 0.000000000 seconds" size="0" pos="0" show="0.000000000"/>
# <field name="frame.time_relative" showname="Time since reference or first frame: 0.000000000 seconds" size="0" pos="0" show="0.000000000"/>
# <field name="frame.number" showname="Frame Number: 1" size="0" pos="0" show="1"/>
# <field name="frame.len" showname="Frame Length: 74 bytes (592 bits)" size="0" pos="0" show="74"/>
# <field name="frame.cap_len" showname="Capture Length: 74 bytes (592 bits)" size="0" pos="0" show="74"/>
# <field name="frame.marked" showname="Frame is marked: False" size="0" pos="0" show="0"/>
# <field name="frame.ignored" showname="Frame is ignored: False" size="0" pos="0" show="0"/>
# <field name="frame.protocols" showname="Protocols in frame: eth:ethertype:ip:icmp:data" size="0" pos="0" show="eth:ethertype:ip:icmp:data"/>
# </proto>
#   <proto name="eth" showname="Ethernet II, Src: 20:f4:1b:80:00:02 (20:f4:1b:80:00:02), Dst: 78:a3:51:03:9e:98 (78:a3:51:03:9e:98)" size="14" pos="0">
#     <field name="eth.dst" showname="Destination: 78:a3:51:03:9e:98 (78:a3:51:03:9e:98)" size="6" pos="0" show="78:a3:51:03:9e:98" value="78a351039e98">
#       <field name="eth.dst_resolved" showname="Destination (resolved): 78:a3:51:03:9e:98" hide="yes" size="6" pos="0" show="78:a3:51:03:9e:98" value="78a351039e98"/>
# <field name="eth.addr" showname="Address: 78:a3:51:03:9e:98 (78:a3:51:03:9e:98)" size="6" pos="0" show="78:a3:51:03:9e:98" value="78a351039e98"/>
# <field name="eth.addr_resolved" showname="Address (resolved): 78:a3:51:03:9e:98" hide="yes" size="6" pos="0" show="78:a3:51:03:9e:98" value="78a351039e98"/>
# <field name="eth.lg" showname=".... ..0. .... .... .... .... = LG bit: Globally unique address (factory default)" size="3" pos="0" show="0" value="0" unmaskedvalue="78a351"/>
# <field name="eth.ig" showname=".... ...0 .... .... .... .... = IG bit: Individual address (unicast)" size="3" pos="0" show="0" value="0" unmaskedvalue="78a351"/>
# </field>
#     <field name="eth.src" showname="Source: 20:f4:1b:80:00:02 (20:f4:1b:80:00:02)" size="6" pos="6" show="20:f4:1b:80:00:02" value="20f41b800002">
#       <field name="eth.src_resolved" showname="Source (resolved): 20:f4:1b:80:00:02" hide="yes" size="6" pos="6" show="20:f4:1b:80:00:02" value="20f41b800002"/>
# <field name="eth.addr" showname="Address: 20:f4:1b:80:00:02 (20:f4:1b:80:00:02)" size="6" pos="6" show="20:f4:1b:80:00:02" value="20f41b800002"/>
# <field name="eth.addr_resolved" showname="Address (resolved): 20:f4:1b:80:00:02" hide="yes" size="6" pos="6" show="20:f4:1b:80:00:02" value="20f41b800002"/>
# <field name="eth.lg" showname=".... ..0. .... .... .... .... = LG bit: Globally unique address (factory default)" size="3" pos="6" show="0" value="0" unmaskedvalue="20f41b"/>
# <field name="eth.ig" showname=".... ...0 .... .... .... .... = IG bit: Individual address (unicast)" size="3" pos="6" show="0" value="0" unmaskedvalue="20f41b"/>
# </field>
#     <field name="eth.type" showname="Type: IP (0x0800)" size="2" pos="12" show="2048" value="0800"/>
# </proto>
#   <proto name="ip" showname="Internet Protocol Version 4, Src: 192.168.100.100 (192.168.100.100), Dst: 14.17.32.211 (14.17.32.211)" size="20" pos="14">
#     <field name="ip.version" showname="Version: 4" size="1" pos="14" show="4" value="45"/>
# <field name="ip.hdr_len" showname="Header Length: 20 bytes" size="1" pos="14" show="20" value="45"/>
# <field name="ip.dsfield" showname="Differentiated Services Field: 0x00 (DSCP 0x00: Default; ECN: 0x00: Not-ECT (Not ECN-Capable Transport))" size="1" pos="15" show="0" value="00">
# <field name="ip.dsfield.dscp" showname="0000 00.. = Differentiated Services Codepoint: Default (0x00)" size="1" pos="15" show="0" value="0" unmaskedvalue="00"/>
# <field name="ip.dsfield.ecn" showname=".... ..00 = Explicit Congestion Notification: Not-ECT (Not ECN-Capable Transport) (0x00)" size="1" pos="15" show="0" value="0" unmaskedvalue="00"/>
# </field>
#     <field name="ip.len" showname="Total Length: 60" size="2" pos="16" show="60" value="003c"/>
# <field name="ip.id" showname="Identification: 0x087c (2172)" size="2" pos="18" show="2172" value="087c"/>
# <field name="ip.flags" showname="Flags: 0x00" size="1" pos="20" show="0" value="00">
# <field name="ip.flags.rb" showname="0... .... = Reserved bit: Not set" size="1" pos="20" show="0" value="00"/>
# <field name="ip.flags.df" showname=".0.. .... = Don&apos;t fragment: Not set" size="1" pos="20" show="0" value="00"/>
# <field name="ip.flags.mf" showname="..0. .... = More fragments: Not set" size="1" pos="20" show="0" value="00"/>
# </field>
#     <field name="ip.frag_offset" showname="Fragment offset: 0" size="2" pos="20" show="0" value="0000"/>
# <field name="ip.ttl" showname="Time to live: 64" size="1" pos="22" show="64" value="40"/>
# <field name="ip.proto" showname="Protocol: ICMP (1)" size="1" pos="23" show="1" value="01"/>
# <field name="ip.checksum" showname="Header checksum: 0x0000 [validation disabled]" size="2" pos="24" show="0" value="0000">
# <field name="ip.checksum_good" showname="Good: False" size="2" pos="24" show="0" value="0000"/>
# <field name="ip.checksum_bad" showname="Bad: False" size="2" pos="24" show="0" value="0000"/>
# </field>
#     <field name="ip.src" showname="Source: 192.168.100.100 (192.168.100.100)" size="4" pos="26" show="192.168.100.100" value="c0a86464"/>
# <field name="ip.addr" showname="Source or Destination Address: 192.168.100.100 (192.168.100.100)" hide="yes" size="4" pos="26" show="192.168.100.100" value="c0a86464"/>
# <field name="ip.src_host" showname="Source Host: 192.168.100.100" hide="yes" size="4" pos="26" show="192.168.100.100" value="c0a86464"/>
# <field name="ip.host" showname="Source or Destination Host: 192.168.100.100" hide="yes" size="4" pos="26" show="192.168.100.100" value="c0a86464"/>
# <field name="ip.dst" showname="Destination: 14.17.32.211 (14.17.32.211)" size="4" pos="30" show="14.17.32.211" value="0e1120d3"/>
# <field name="ip.addr" showname="Source or Destination Address: 14.17.32.211 (14.17.32.211)" hide="yes" size="4" pos="30" show="14.17.32.211" value="0e1120d3"/>
# <field name="ip.dst_host" showname="Destination Host: 14.17.32.211" hide="yes" size="4" pos="30" show="14.17.32.211" value="0e1120d3"/>
# <field name="ip.host" showname="Source or Destination Host: 14.17.32.211" hide="yes" size="4" pos="30" show="14.17.32.211" value="0e1120d3"/>
# <field name="" show="Source GeoIP: Unknown" size="4" pos="26" value="c0a86464"/>
# <field name="" show="Destination GeoIP: Unknown" size="4" pos="30" value="0e1120d3"/>
# </proto>
#   <proto name="icmp" showname="Internet Control Message Protocol" size="40" pos="34">
#     <field name="icmp.type" showname="Type: 8 (Echo (ping) request)" size="1" pos="34" show="8" value="08"/>
# <field name="icmp.code" showname="Code: 0" size="1" pos="35" show="0" value="00"/>
# <field name="icmp.checksum" showname="Checksum: 0x4b92 [correct]" size="2" pos="36" show="19346" value="4b92"/>
# <field name="icmp.checksum_bad" showname="Bad Checksum: False" hide="yes" size="2" pos="36" show="0" value="4b92"/>
# <field name="icmp.ident" showname="Identifier (BE): 1 (0x0001)" size="2" pos="38" show="1" value="0001"/>
# <field name="icmp.ident" showname="Identifier (LE): 256 (0x0100)" size="2" pos="38" show="256" value="0001"/>
# <field name="icmp.seq" showname="Sequence number (BE): 457 (0x01c9)" size="2" pos="40" show="457" value="01c9"/>
# <field name="icmp.seq_le" showname="Sequence number (LE): 51457 (0xc901)" size="2" pos="40" show="51457" value="01c9"/>
# <field name="data" value="6162636465666768696a6b6c6d6e6f7071727374757677616263646566676869">
# <field name="data.data" showname="Data: 6162636465666768696a6b6c6d6e6f707172737475767761..." size="32" pos="42" show="61:62:63:64:65:66:67:68:69:6a:6b:6c:6d:6e:6f:70:71:72:73:74:75:76:77:61:62:63:64:65:66:67:68:69" value="6162636465666768696a6b6c6d6e6f7071727374757677616263646566676869"/>
# <field name="data.len" showname="Length: 32" size="0" pos="42" show="32"/>
# </field>
#   </proto>
# </packet>
#
#
# </pdml>
# print `tshark -ni "dut"  -T pdml -a duration:1`
#  print `tshark -ni "dut"  -T pdml -c 1 -V`

#与cmd窗口显示的差不多
# print `tshark -ni "dut"  -T ps -a duration:2`
# print `tshark -ni "dut"  -T ps -a duration:2 -V`

#与cmd窗口显示的差不多格式化为xml
# <packet>
# <section>7</section>
# <section>0.986028</section>
# <section>20:f4:1b:80:00:02</section>
# <section>ff:ff:ff:ff:ff:ff</section>
# <section>ARP</section>
# <section>42</section>
# <section>Who has 192.168.100.1?  Tell 192.168.100.100</section>
# </packet>
# print `tshark -ni "dut"  -T psml -a duration:2`

#Text
# 1   0.000000 20:f4:1b:80:00:02 -> 78:a3:51:03:9e:98 ARP 42 Who has 192.168.100.1?  Tell 192.168.100.100
# 2   0.000801 78:a3:51:03:9e:98 -> 20:f4:1b:80:00:02 ARP 60 192.168.100.1 is at 78:a3:51:03:9e:98
# 3   7.026153 192.168.100.100 -> 14.17.32.211 ICMP 74 Echo (ping) request  id=0x0001, seq=5/1280, ttl=64
# 4   7.032861 14.17.32.211 -> 192.168.100.100 ICMP 74 Echo (ping) reply    id=0x0001, seq=5/1280, ttl=53 (request in 3)
# 5   8.027402 192.168.100.100 -> 14.17.32.211 ICMP 74 Echo (ping) request  id=0x0001, seq=6/1536, ttl=64
# 6   8.043070 14.17.32.211 -> 192.168.100.100 ICMP 74 Echo (ping) reply    id=0x0001, seq=6/1536, ttl=53 (request in 5)
# 7   9.029429 192.168.100.100 -> 14.17.32.211 ICMP 74 Echo (ping) request  id=0x0001, seq=7/1792, ttl=64
#  print `tshark -ni "dut"  -T text -a duration:2`
# print `tshark -ni "dut"  -T text -a duration:30 -V`

"22222"

