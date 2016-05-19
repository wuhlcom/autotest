# int  pcap_findalldevs_ex (char *source, struct pcap_rmtauth *auth, pcap_if_t **alldevs, char *errbuf)
# 创建一个网络设备列表，它们可以由 pcap_open()打开。
require 'ffi'
module HelloWin
  extend FFI::Library
  ffi_lib 'wpcap'
  ffi_convention :stdcall

  attach_function :message_box, :MessageBoxA, [:pointer, :string, :string, :uint], :int
end