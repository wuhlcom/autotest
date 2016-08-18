require 'execjs'
context='window.opener.location.href="http://192.168.10.9:8083/index.php/Login/index?code=047310ff3abd8ae9e41725efb42c04de&ssid=MmVnYzgzYWRya2M1Yzd2OGxrNXUzdXViYWsyMWxtaDU=";window.
    close()'
contexobj = ExecJS.compile(context)
p contexobj.call 'window.opener.location.href'