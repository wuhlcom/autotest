# Example for pcap_lookupnet for the first device :
require 'ffi'
require 'ffi/pcap'

p dev    = FFI::PCap.device_names.first
p dev    = FFI::PCap.device_names
netp   = FFI::MemoryPointer.new(FFI::find_type(:bpf_uint32))
maskp  = FFI::MemoryPointer.new(FFI::find_type(:bpf_uint32))
errbuf = FFI::PCap::ErrorBuffer.new

FFI::PCap.pcap_lookupnet dev, netp, maskp, errbuf

puts netp.get_array_of_uchar(0, 4).join('.')
puts maskp.get_array_of_uchar(0, 4).join('.')

# Example for pcap_findalldevs :

require 'ffi/pcap'

devices = FFI::MemoryPointer.new(:pointer)
errbuf  = FFI::PCap::ErrorBuffer.new

FFI::PCap.pcap_findalldevs(devices, errbuf)
node = devices.get_pointer(0)
dev  = FFI::PCap::Interface(node) # return a structure object for exploring :

dev.name
dev.description
dev.addresses
dev.addresses.addr

FFI::PCap.pcap_freealldevs(node)


# LISTENING RAW PACKET
# We¡¯ve got our active device, so let listen to packets :

require 'ffi/cap'

dev = FFI::PCap.device_names[1] # or another for you

pcap = FFI::PCap::Live.new(:dev => dev) # for this time, listening is active, as show with stats

pcap.stats
pcap.stats.ps_recv

pcap.datalink.describe

pakt = []

pcap.loop(:count => 1) do |this, pkt| # :count => -1 for infinite loop, break with .breakloop method
  pakt << pkt
  puts "#{pkt.time} :: #{pkt.len}"
  pkt.body.each_byte { |x| print "%0.2x " % x }
  putc "\n"
end

# The first packet ! :)

# FILTERING
# The filter is set before the loop. Start by the man page with lot of examples : http://www.manpagez.com/man/7/pcap-filter/

set_filter = "port 80" # simple filter
# Now let¡¯s look into this packet ¡­

# HEXDUMP
# Start first with a better hexdump look with ¡­ Hexdump gem :) (gem i hexdump) :
pcap.loop(count: 2) { |t, p| Hexdump.dump(p.body); puts "\n"; };

# render :
#  00000000  33 33 00 00 00 0c 74 e5 43 82 96 a2 86 dd 60 00  |33....t.C.....`.|
# 00000010  00 00 00 9a 11 01 fe 80 00 00 00 00 00 00 1c 3e  |...............>|
# 00000020  c1 df 18 3d 8d ea ff 02 00 00 00 00 00 00 00 00  |...=............|
# ...
# ETHERNET FRAME STRUCTURE
# We are on OSI level 2, so our ¡®packet¡¯ are in reality some ¡®frame¡¯ (packet denomination is for level 3 OSI) :check http://en.wikipedia.org/wiki/OSI_model#Examples.
#
# | Destination MAC address | Source MAC address | Type/Length | User Data |
# | :---------------------: | :----------------: | :---------: | :-------: |
# |     vendor  /    id     |  vendor  /    id   |             |           |
# |       3     /    3      |    3     /    3    |      2      | 46 - 1500 |
# The list of vendor / organization can be found here http://anonsvn.wireshark.org/wireshark/trunk/manuf or here http://standards.ieee.org/develop/regauth/oui/oui.txt.
#
# A short script to transform the wireshark database (saved as ./manuf) into a local YAML hash :

def create_manuf
  ctr = {}
  File.readlines("./manuf").each do |line|
    line =~ /^([^\s]+)\s+([^#]+)(\s+#(.*))?$/
    ctr[$1] = {:sh => ($2 ? $2.strip : $2), :lg => ($4 ? $4.strip : $4)}
  end
  File.open("./manuf.yaml", "w+") { |f| f.write(ctr.to_yaml) }
  return ctr
end

# ie ctr["00:00:0C"] give a short and a long name of the constructor.
# Nota: A destination MAC address of ff:ff:ff:ff:ff:ff indicate a broadcast message from the source.#
# ANALYZING ETHERNET FRAME
# First get a full frame :
frame = ''
pcap.loop(count: 1) { |t, p| frame = p.body }
# And then initialize FFI::Packets::Eth :

eth = FFI::Packets::Eth.new raw: frame
# and get the MAC source and destination adresse and the type :

puts eth.dump
eth.src
eth.lookup_etype
# Nota : the ffi-packets gem need some adjustments (the gemspec isn¡¯t complete), you can use my fork for the moment.
# Nota 2 : read the source of ffi/dry, ffi/pcap and ffi/packets for better understanding the usage.