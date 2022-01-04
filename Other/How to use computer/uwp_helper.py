
import os
import winreg as wr
 
# 参考文档：https://www.cnblogs.com/tangfeibiao/p/3405748.html
 
 
BASE_PATH = r"Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Mappings"
 
 
# 获得所有程序的 SID
def get_apps_sid():
    sid_list = []
    with wr.OpenKeyEx(wr.HKEY_CURRENT_USER, BASE_PATH) as key:
        max_index = wr.QueryInfoKey(key)[0]
        print(key)
        for i in range(max_index):
            sid_list.append(wr.EnumKey(key, i))
    return sid_list
 
 
# 开启UWP应用使用代理
def enable_all_uwp_net():
    sid_list = get_apps_sid()
    for sid in sid_list:
        os.system('CheckNetIsolation.exe loopbackexempt -a -p=' + sid)
 
 
# 关闭UWP应用使用代理
def disable_all_uwp_net():
    sid_list = get_apps_sid()
    for sid in sid_list:
        os.system('CheckNetIsolation.exe loopbackexempt -d -p=' + sid)
 
 
enable_all_uwp_net()