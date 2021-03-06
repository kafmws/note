# Symbol Management

## 符号表概念
符号表是编译器保存信息的中心库，编译器的各部分通过符号表进行交互，并访问符号表中的数据——符号。
例如，
`词法分析器`把`标识符`加入标识符表中；
由`分析器`添加这些标识符的类型信息；
`代码生成器`则为符号表中各个表项添加与目标相关的信息，如局部变量和参数的寄存器分配信息；

符号表把各种名字映射到符号集合。常量、标识符和标号都是`名字`，不同的名字有不同的`属性`。
例如，作为局部变量名的标识符包括变量的类型、该变量在其声明所在过程的栈帧中的位置以及存储类型；
而作为结构体成员名的标识符则具有完全不同的属性集，包括成员的类型、所在的结构及其在结构中的位置。

符号管理不仅要处理符号本身，还要遵循`ANSI C`规定的`作用域(scope)`或`可见性(visibility)`规则。
标识符的作用域是指在程序中该标识符可见的部分、有效的部分。
`C`的作用域可以嵌套，一个标识符的可见范围是从该标识符的声明点开始，直到其声明所在的`复合语句`或`参数列表`结束。
在所有符合语句或参数列表以外声明的标识符具有文件作用域，其可见范围从声明点开始直到其所在的源文件结束。
在`C`语言中，内层声明的标识符`X`会隐藏外层声明的标识符`X`，即内层同名标识符的作用域形成了外层同名标识符的“空洞”。
符号管理必须要处理这种情况，维护名字与变量之间正确的映射关系。

在“大多数”语言中，如`Pascal`，标识符只有一个命名空间，即各种用途的标识符都在一个统一的集合中。
在程序的任何地方，对于给定的名字只有一个标识符可见。
`ANSI C`按照用途对标识符的命名空间进行分类：`语句标号`、`标记(tag)`、`成员`、`一般标识符`。
`标记`表示`结构体`、`共用体`和`枚举`的名字（PS:笔者称`类型名`，原书称`tag`，译文称`标记`或`类型标记`，特指结构体、共用体和枚举声明时所用的名字）。因此有标号、类型名和一般标识符三个命名空间。
对于每个结构体和共用体，其成员都有独立的命名空间。
在程序的同一位置，给定的名字在每个命名空间中最多只有一个对应的标识符可见。也就是说，程序任意一处可能存在多个同名标识符可见，但它们位于不同命名空间，使用方式也有所区别。

粗略地说，不同的命名空间拥有独立的符号表，每个符号表处理各自符号的作用域。
`lcc`还使用了独立的符号表来处理`无作用域集合(unscoped collection)`，如常量。
符号表模块的实现在`sym.c`中。

## 符号的表示
`lcc`中的符号以如下结构表示，
```C
typedef struct symbol *Symbol;

struct symbol {
    char        *name;
    int         scope;
    Coordinate  src;
    Symbol      up;
    List        uses;
    int         sclass;

    //symbol flags  
    unsigned    structarg:1;
    unsigned    computed:1;
    unsigned    temporary:1;
    unsigned    generated:1;
    unsigned    defined:1;

    Type        type;
    float       ref;
    union{
        //<labels>
        //<struct types>
        //<enum constants>
        //<enum types>
        //<constants>
        //<function symbols>
        //<globals>
        //<temporaries>
    } u;
    Xsymbol x;
    //<debugger extension>
};
```