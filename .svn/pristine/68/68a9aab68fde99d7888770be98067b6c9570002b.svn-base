# int pcap_findalldevs  ( pcap_if_t **  alldevsp,
#                         char *  errbuf
#     )

# devices = FFI::MemoryPointer.new(:pointer)
# errbuf  = ErrorBuffer.new
#
# PCap.pcap_findalldevs(devices, errbuf)
# node = devices.get_pointer(0)
#
# if node.null?
#   raise(LibError,"pcap_findalldevs(): #{errbuf}",caller)
# end
#
# device = Interface.new(node)
#
# while device
#   yield(device)
#
#   device = device.next
# end
#
# PCap.pcap_freealldevs(node)
# return nil


require 'ffi'
module Finddevs
  extend FFI::Library
  ffi_lib('wpcap')
  # ffi_convention(:stdcall)
  attach_function(:findalldevs, :pcap_findalldevs, [:pointer,:pointer], :int)
end
nic     = '\\Device\\NPF_{C3FC08EA-71A1-4DE5-957F-4B9648D96562}'
devices = FFI::MemoryPointer.new(:pointer)
errbuf  = FFI::Buffer.new(256)
p Finddevs.findalldevs(devices,errbuf)
p node = devices.get_pointer(0)
p device = Interface.new(node)
while device
  # yield(device)
  p device = device.next
end

