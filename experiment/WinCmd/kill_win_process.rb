module DealWindows
#功能说明：
#- 根据系统进程名，杀掉对应的系统进程
#
#参数说明：
#- name：进程名称
#
#调用示例：
#- kill_process('EXCEL.EXE')
#
#返回值说明：
#-  成功：返回true
#-  失败：返回出错信息
  def kill_process(name)
    begin
      wmi = WIN32OLE.connect("winmgmts://")
      processes = wmi.ExecQuery("select * from win32_process where name='#{name}'")

      for process in processes
        process.terminate()
        sleep 0.2
      end

      return true
    rescue => err
      $LOG.fatal(err)
      raise err
    end
  end

end # class DealWindows end