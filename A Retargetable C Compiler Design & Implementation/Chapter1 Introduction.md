# Introduction

本章讲述了本书的阅读方式，`lcc`的基本概况、设计理念、`lcc`的工作过程和`lcc`项目中使用的一些公共声明，主要包括一些兼容性宏及功能性宏。

> 与许多`Unix`编译器一样，`lcc`使用独立的预处理器并且预处理器作为一个独立的进程执行。

> 根据目标机器的调用约定来产生代码序列，这样才能利用现有的库。

> `lcc`的前端大概有`9000`行代码，每种与目标相关的代码生成器有`700`行代码。还有约`1000`行与目标无关、由所有代码生成器共享的后端代码。

> `lcc`后端使用代码生成器产生器`lburg`，该产生器可以根据紧缩规范产生代码生成程序。

> 经验表明，如果为某些语句生成不同目标的代码的过程几乎相同，那么这些语句的代码生成或许可以以后端无关的方式实现，即完全在前端实现。

---

```C
#define NULL ((void *)0)
```
> 以宏 `NULL` 代替 0 值，在整数和指针类型长度不一致的情况下避免错误

---

```C
#define roundup(x, n) ((x+((n)-1))&(~((n)-1)))
```
> `roundup(x, n)`返回不小于`x`且离`x`最近的`n`的倍数，`n`是`2`的幂。该宏等价与`(x + n-1)%n`。

```C
#define NELEMS(a) ((int)(sizeof (a)/sizeof ((a)[0])))
```
> 返回使用`sizeof`运算符进行计算的数组大小，当然参数`a`必须是数组名。

---

> `EBNF`，扩展巴科斯范式，`|`表示左右两边选其一，`[]`表示其中内容可选，即可出现可不出现，`{}`表示其中内容可重复`0`至若干次。`()`用来分组。
非终结符用斜体显示，非终结符用等宽字体显示，`'('`表示终结符`(`
&emsp;
PS:EBNF中`[]`中的内容选择与否可能使`[]`前的产生式有着截然不同的含义
如：
`IF '(' expr ')' THEN statement [ ELSE statement ]`
上式中，`ELSE`分句出现与否不影响前面`IF ... THEN ...`语句的意义
而在下式
`factor: ID [ '(' expr {, expr} ')' ] | '(' expr ')'`
中，左边的产生式`ID [ '(' expr {, expr} ')' ]` 若不取可选部分，可表示一个普通`ID`，而`ID '(' expr {, expr} ')'`将表示一个函数调用，`ID`被限定为一个函数名。

> 