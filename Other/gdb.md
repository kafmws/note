# GDB的使用
###### 启动GDB调试器
```bash
#-q参数减少无关信息的输出
gdb -q
```
#### 基本命令
|命令       |参数       |作用        |
|-----------|-----------|-----------|
|file       |\<filename\> |加载要调试的可执行文件|
|set args   |arg1 arg2    |设定程序参数         |
|show args  |           |显示程序执行参数       |
|b, break   |[filename.c:]代码行号    |[指定文件]设置断点   |
|r, run     |           |运行程序   |
|l, list    |           |列出当前行前后代码段|
|s, step    |           |step into  |
|n, next    |           |step over  |
|p, print   |变量、表达式、语句等|打印变量/表达式值|
|display |变量、表达式、语句等|持续打印|
|backtrace ||打印堆栈|
|thread ||显示进程/线程|
|q, quit    |           |退出       |



-------