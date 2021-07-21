<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=5 orderedList=false} -->

<!-- code_chunk_output -->

- [使用 Python 库](#使用-python-库)
    - [import 的几种使用方式](#import-的几种使用方式)
    - [数值类型](#数值类型)
- [字符串常用操作](#字符串常用操作)
- [](#)

<!-- /code_chunk_output -->

### 使用 Python 库

##### import 的几种使用方式

```Python
import turtle
turtle.turtle_function()
```

```Python
from turtle import * # from turtle import some_function
#可能发生命名冲突
turtle_function()
```

```Python
import turtle as t
#简化库名并避免命名冲突
t.turtle_function()
```

##### 数值类型

`Python`支持无限制长度的整数类型、IEEE754 浮点数（可用科学计数法表示）和复数类型
宽度依次扩大，不同类型数值变量的运算结果会提升至运算数的最大宽度

```Python
abs(x)              #绝对值
round(num[, 位数=0])#四舍五入取整
divmod(x)           #返回二元组(商，余数)
pow(x,y[,z])        #x的y次方，参数z若存在则返回对z取模结果
max(x1,x2...xn)     #返回序列中最大值
min(x1,x2...xn)     #返回序列中最小值
int(x)              #将x转换或解析为int值
float(x)            #将x转换或解析为float值
complex(x)          #将x转换或解析为复数

omplex.real         #获得复数实部
complex.imag        #获得复数虚部
x//y                #整除
x**y                #x的y次方

```

### 字符串常用操作

`Python`支持两类四种字符串表示形式。

```Python
'the first'
"the second"
'''the third'''

```

- 部分常用操作

|       语法        |          语义或备注          |
| :---------------: | :-------------------------: |
| `str[index]` |`indexOf()`，`str[-1]`即`str[len(str)-1]`|
| `str[begin=0:end=len-1]` | `substring()`，[begin,end)|
|  `str[begin,end,step]`   | `substringWithStep()`<br>e.g.`"0123456"[::2] ==> "0246"`<br>`"0123"[::-1] ==> "3210"` |
|       `str1+str2`        |`contact()`|
|`str*x`或`x*str`|得到将 str 重复 n 遍的字符串|
|`str1 in str2`|`str2.indexOf(str1)!=-1`或`str2.contains(str1)`|

- 字符串函数

|       函数       |          描述          |
|:---------------: | :--------------------: |
|`len(str)`|返回字符串长度|
|`str(x)`|将任意类型值x转换为字符串|
|`hex(x)`/`oct(x)`|将整数x转换为十六进制或八进制小写字符串<br>e.g.`hex(15) ==> "0xf"`|
|`chr(u)`/`ord(ch)`|unicode编码与字符（长度为1的字符串）间进行转换<br>`ord('草')  ==> 33609`|
|||

- 字符串处理方法

字符串类的一些方法
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/Python字符串类方法.png" alt="Python字符串类方法" width="80%">

- 字符串的格式化


### 

```Python
range([begin=0,] end)           #生成[begin, end)的整数序列

eval("python statement")        #执行字符串形式的Python语句
```
