# pcap_t* pcap_open  ( const char *  source,
#                       int  snaplen,
#                       int  flags,
#                       int  read_timeout,
#                       struct pcap_rmtauth *  auth,
#                       char *  errbuf
# )

# int pcap_sendpacket  ( pcap_t *  p,
#                        u_char *  buf,
#                        int  size
#     )
require 'ffi'
module Wpcap
  extend FFI::Library
  ffi_lib('wpcap')
  # ffi_convention(:stdcall)
  class OpenNIC <FFI::Struct
    layout :type, :int,
           :usrname, :pointer,
           :passwd, :pointer
  end
  attach_function(:open_nic, :pcap_open, [:pointer, :int, :int, :int, :pointer, :pointer], :pointer)
  # attach_function(:sendpacket, :pcap_sendpacket, [:pcap_t, :pointer, :int], :int)
end

module Send
  extend FFI::Library
  ffi_lib('wpcap')
  attach_function(:sendpacket, :pcap_sendpacket, [:pointer, :pointer, :int], :int)
end

nic     = '\\Device\\NPF_{C3FC08EA-71A1-4DE5-957F-4B9648D96562}'
devices = FFI::MemoryPointer.new(:pointer)
auth    = Wpcap::OpenNIC.new
errbuf  = FFI::Buffer.new(256)
p pcap    = Wpcap.open_nic(nic, 100, 1, 2, nil, errbuf)
arr     ="fffffff012345"
for i in 12..100
  arr<<i%256
end
p arr.size
p Send.sendpacket(pcap,arr,100)
# p Wpcap.sendpacket('\\Device\\NPF_{C3FC08EA-71A1-4DE5-957F-4B9648D96562}', devices, 255)
