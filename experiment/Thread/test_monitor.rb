require 'monitor'
class ThreadTest
		include MonitorMixin

		# resource,ͬ����Դ
		attr_accessor :sources,:cond

		def initialize
				# ע��,����Լ�дinitialize������super����ʡ��
				super
				self.cond = new_cond
				self.sources = []
		end

		# ������
		# ��2���̲߳�ͣ����resource��������Դ
		def start_producer_thread
				ts = []
				2.times do |i|
						ts << Thread.new do
								Thread.current[:name] = "producer thread #{i + 1}"
								loop do
										synchronize do
												p = sources.size == 0 ? 1 : sources.last + 1
												self.sources << p
												puts "[#{Thread.current[:name]}] create one product : #{p.to_s.rjust(4)}"
												cond.signal
												sleep 0.2
										end
								end
						end
				end
				ts
		end

		# ������
		# ��3���̲߳�ͣ�Ĵ���Դ��resource����ȡ��
		def start_consumer_thread
				ts = []
				3.times do |i|
						ts << Thread.new do
								Thread.current[:name] = "consumer thread #{i + 1}"
								loop do
										synchronize do
												p = sources.shift
												puts "[* #{Thread.current[:name]}] consume one product : #{p.to_s.rjust(8)}"
												cond.signal
										end
								end
						end
				end
				ts
		end

		def do_it
				ts = []
				# �������߳̿�ʼ
				ts << start_producer_thread
				sleep 1
				# 1���Ӻ��������߳̿�ʼ
				ts << start_consumer_thread
				# �������߲��̣�ֱ�����������������߳̽���
				ts.flatten.each(&:join)
		end
end
ThreadTest.new.do_it