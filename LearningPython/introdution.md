<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=5 orderedList=false} -->

<!-- code_chunk_output -->

- [Python及其标准库](#python及其标准库)
  - [基础使用](#基础使用)
    - [循环](#循环)
    - [import 的几种使用方式](#import-的几种使用方式)
    - [数值类型](#数值类型)
    - [字符串常用操作](#字符串常用操作)
    - [字符串的格式化](#字符串的格式化)
    - [异常处理](#异常处理)
  - [标准库](#标准库)
    - [turtle库](#turtle库)
    - [time库](#time库)
    - [random库](#random库)

<!-- /code_chunk_output -->

## Python及其标准库

### 基础使用

#### 循环
- `for ... in ...`循环
```Python
for <循环变量> in <循环结构>:
  <循环语句>
```
循环结构可以是：数组（数组元素），字符串（字符），列表（表项），字符文件（行）等可遍历结构...

- 循环语句与`else`

当循环语句未被`break`语句退出时，循环结束后，执行`else`语句块
（与异常处理中`else`语句块相似）
```Python
for i in range():
  ...
else:
  ...

while ...:
  ...
else:
```

#### import 的几种使用方式

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

#### 数值类型

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

complex.real        #获得复数实部
complex.imag        #获得复数虚部
x//y                #整除
x**y                #x的y次方

```

- 其他常用函数
```Python
range([begin=0,] end[, step=1])   #生成[begin, end)的整数序列

eval("python statement")          #执行字符串形式的Python语句
```

#### 字符串常用操作

`Python`支持两类四种字符串表示形式。

```Python
'the first'
"the second"
'''the third'''         #可换行，所以可作为多行注释使用

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

- 字符串处理方法

字符串类的一些方法
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/Python字符串类方法.png" alt="Python字符串类方法" width="80%">

#### 字符串的格式化

使用模板字符串进行字符串的格式化
```Python
#2021/7/22:计算机C的CPU占用率为20%
"{}:计算机{}的CPU占用率为{}%".format("2021/7/22","C",20)
```
参数默认按从左至右的顺序填充

- 参数控制标记
格式：{<参数序号>:<格式控制标记>}

|:|<填充>|<对齐>|<宽度>|<,>|<.精度>|<类型>|
|:--:|:--:|:--:|:--:|:--:|:--:|:--|
|引导符号|填充字符|<左对齐<br>>右对齐<br>^居中|参数输出宽度|千位分隔符|浮点数小数精度<br>或<br>字符串最大输出长度|整数类型<br>b,c,d,o,x,X<br>浮点数类型<br>e,E,f,%|

```Python
#2021/7/22:20号计算机的CPU占用率为20.00%
"{1}:{0:d}号计算机的CPU占用率为{0:.2f}%".format(20, "2021/7/22")

#   2021/7/22:
#计算机C的CPU占用率为24.53%
print("{:>12}:\n计算机{}的CPU占用率为{:.2%}".format("2021/7/22","C",0.24526))
```

#### 异常处理
```Python
#执行try语句块，若发生异常则跳出并执行except语句块
#except后可以选择处理特定类型的Error如NameError

try:
  <statement1>
except [ErrorType1]:# 产生ErrorType1时执行
  <statement2>
except [ErrorType2]:
  <statement2>
except:             # 其余所有类型Error
  <statement3>
```

- 完整形式

```Python
try:
  <statement1>
except:             
  <statement2>
else:               # try中未发生异常时执行
  <statement3>
finally:            # 必定执行
  <statement4>
```
---

### 标准库

Python标准库即随解释器安装的库，无需额外安装。

#### turtle库
turtle库是`turtle`绘图体系的Python实现
入门级图形绘制函数库

一只海龟作为画笔，控制海龟的运动轨迹形成图形，最小绘制单位为像素
- turtle库的设计视角

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/turtle绘图窗体.png" alt="turtle绘图窗体" width="60%">
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/turtle库坐标与角度.png" alt="turtle库坐标与角度" width="100%">

海龟默认方向水平向右，初始位置(0,0)，即画布中央。
有一系列函数从绝对坐标系/角度与海龟坐标系/角度控制海龟的方向。

- 绘图设置

```Python
#设置绘图窗口，宽，高，窗口起始坐标（默认窗口居中）
turtle.setup(width, height[, startx, straty])

#设置画笔颜色，参数可为：
#颜色名称（"white"）、RGB整数（255,255,255）、RGB小数（1,1,1）等类别，RGB格式默认采用小数
turtle.pencolor()

#设置RGB格式，参数为1.0表示小数值模式，255表示整数值模式
turtle.colormode()

#设置画笔大小，单位为像素
turtle.pensize()

#绘图结束后，保留画布窗口，调用后无法继续绘图
turtle.down()
```
**turtle色彩表**
<details>
    <summary>点击查看详细内容</summary>
    <img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/RGB色彩表.png" alt="RGB色彩表" width="80%">
</details>
<br>

- 控制函数

```Python
#画笔抬起，抬起后移动海龟不留下路径
turtle.penup()      # aka turtle.pu()

#画笔落下，落下后移动海龟留下路径
turtle.pendown()    # aka turtle.pd()

#直线移动至(x, y)
turtle.goto(x, y)

#以绝对角度设置方向
turtle.sethead()    # aka turtle.seth()

#以海龟角度旋转方向
turtle.left()       # 前进左转若干度
turtle.right()      # 前进右转若干度

#前进若干像素，当参数为负数时后退，方向不变
turtle.forward()    # aka turtle.fd()

#圆周运动，以左侧垂直前进方向距离r为圆心做圆心角为angle的圆心运动
#参数r为负数时，即垂直前进方向右侧距离r为圆心。
turtle.circle(r, angle)
```

---

#### time库
几乎提供与C标准库`time.h`相同的功能

- 时间获取

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/time库时间获取函数.png" alt="time库时间获取函数" width="80%">

- 时间结构体与时间字符串相互转换

时间结构体转换为格式化字符串
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/strftime函数.png" alt="strftime函数" width="80%">

格式化时间字符串转换为时间结构体
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/strptime函数.png" alt="strptime函数" width="80%">

- 程序计时

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/计时函数.png" alt="计时函数" width="80%">

**设计进度条的一些函数**

<details>
    <summary>点击查看详细内容</summary>
    <img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/进度条函数.png" alt="进度条函数" width="80%">
</details>

---

#### random库
生成伪随机数的函数库

- 基本随机函数
```Python
# 设定随机数种子，不显式指定时将系统时间作为种子
# 相同随机数种子给出的随机数序列是相同的，使程序运行结果可复现
seed(a=None)

# 返回[0.0, 1.0)中的随机数
random()
```

- 扩展随机函数
```Python
# 生成一个[a, b]之间的整数
randint(a, b)

# 生成一个[m, n)之间，以k为步长的随机整数
# 即在以k为步长，m起始，小于n的数列间随机选取
# 类似 choice(range(m,n,k))
randrange(m,n[,k])

# 生成一个k比特长的随机整数
getrandbits(k)

# 生成一个[a, b]之间的随机小数
uniform(a, b)

# 从序列seq中随机选择一个元素
choice(seq)

# 将序列seq中元素随机排列
shuffle(seq)
```