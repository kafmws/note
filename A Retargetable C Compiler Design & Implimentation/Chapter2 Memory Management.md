<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Memory Management](#memory-management)
  - [lcc 的内存管理](#lcc-的内存管理)
    - [分配区的组成](#分配区的组成)
    - [内存分配过程](#内存分配过程)
        - [内存分配函数](#内存分配函数)
        - [实际分配过程](#实际分配过程)
        - [分配区的释放](#分配区的释放)
    - [字符串的存储](#字符串的存储)
        - [字符串函数](#字符串函数)
  - [Programming Tips](#programming-tips)

<!-- /code_chunk_output -->

# Memory Management

本章介绍了`lcc`的内存管理——如何分配与回收内存。
内存分配与字符串函数的实现分别在文件`alloc.c`和`string.c`中。

## lcc 的内存管理

### 分配区的组成

`lcc`使用名为分配区（`arena`）的结构来动态管理内存，生存期相同的对象在同一个分配区中分配，释放时以分配区为单位释放。每一个分配区都用一个非负整数作为标识，通过这个标识来管理分配区内存的分配与释放。

每个分配区都是由一组很大的内存块构成的链表。
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/arena图示.png" alt="arena图示" width="80%">

`2-1图`表示了`1号分配区`的组成方式——一个单向链表。
其中，`first[1]`是其头节点，`arena[1]`指向`1号分配区`当前用于分配内存的内存块，同时也是这个链表的尾指针。（`first[1]`、`arena[1]`均带有下标是因为这样的分配区有多个，它们的头节点和尾指针都用数组来管理）。每个内存块申请后在头部存放一个块头结构`struct block`（如`first[1]`），用于管理本块，同时形成链表。

内存块块头的数据结构定义如下，

```c
struct block{
    struct block *next;
    char *limit;
    char *avail;
};
```

不难理解，`next`指向该分配区的下一个内存块，`limit`存储该内存块的最大地址，`avail`指向块中可分配区域的首地址。即从`avail`到`limit`之间的空间都是未分配的。

```ditaa {cmd=true args=["-E"] hide=true}
                          /-+--------+              +--------+
                          | |  next  |------------->|  next  |      ------------->...
                          | +--------+              +--------+
            struct block -+ | avail  |--+           | avail  |--+  
                          | +--------+  |           +--------+  |  
                          | | limit  |--+-+         | limit  |--+-+
                          +-+--------+  | |         +--------+  | |
                          | |  cCCC  |  | |         |        |  | |
                          | |        |  | |         |        |  | |
                          | |  used  |  | |         |        |  | |
                          | |        |  | |         |  ...   |  | |
      memmory allocation -+ |        |  | |         |        |  | |
                          | +--------+<-+ |         |        |  | |
                          | |        |    |         |        |  . |
                          | |  ...   |    |         |        |  .
                          | |        |    |         |        |  .
                          | |        |    |         |        |
                          \-+--------+<---+         +--------+
```

`lcc`定义了三个`arena`，由数组将头结点和尾指针组织起来，

```C
static struct block
     first[] = {  { NULL },  { NULL },  { NULL } },
    *arena[] = { &first[0], &first[1], &first[2] };
```

使用宏、枚举变量或者常量等可以更容易地区分多个分配区，

```C
#define PERM 0
#define FUNC 1
#define STMT 2
//arena[FUNC];存放函数信息的分配区
```

### 内存分配过程
##### 内存分配函数

```C
extern void *allocate(unsigned long n, unsigned a);
extern void deallocate(unsigned a);
```

`allocate`在标识符为`a`的分配区分配字节数为`n`的内存，返回该段内存的首地址。
`deallocate`释放标识符为`a`的分配区。

`lcc`中`allocate`通常以宏的方式使用，

```C
#define NEW(p, a) ((p) = allocate(sizeof(*(p)), (a)))
#define NEW0(p, a) memset(NEW((p), (a)), 0, sizeof(*(p)))
//PS: memset以第一个参数作为返回值
```

数组分配函数`newarray`可以调用`allocate`简单实现。

```C
void *newarray(unsigned long m, unsigned long n, unsigned a) {
	return allocate(m*n, a);
}
```

#####  实际分配过程

```C
//用于字节对齐的共用体类型声明

union align {
    long l;
    char *p;
    double d;
    int (*f)(void);
};/*union align包含了代表性的类型，
    严格表示了宿主机的最小对齐字节数*/

union header {
    struct block b;
    union align a;
};//该共用体用于初始化struct block中的avail指针位置
```

`allocate`具体实现为，向编号为`a`的分配区`arena[a]`申请`n`个字节的空间，将`n`字节对齐后，
- 若当前块剩余空间满足请求，分配内存（返回`avail`指针的位置，并将avail向后偏移`n`个字节）；
- 若当前块剩余空间不满足请求
1.依次从`freeblocks`表头取下空闲内存块加至当前分配区表尾直到满足请求分配内存或`freeblocks`为空链转2.；
2.申请新的内存块，初始化块头结构，分配内存。

```C
static struct block *freeblocks;//空闲内存块链，deallocate“释放”的内存块放置在此链表中

void *allocate(unsigned long n, unsigned a) {
    struct block *ap;

    assert(a < NELEMS(arena));
    assert(n > 0);
    ap = arena[a];
    n = roundup(n, sizeof (union align));//字节对齐
    while (n > ap->limit - ap->avail) {//当前内存块剩余空间不足
        if ((ap->next = freeblocks) != NULL) {//若空闲内存块链表不为空，则从表首取一个内存块
            freeblocks = freeblocks->next;
            ap = ap->next;
        } else
            {/*/*freeblocks为空，申请新的内存块，大小为 对齐的struct block字节数(存放表头结构)
            + 调用allocate时要求的n个字节 + 10KB字节对齐后的字节数(用于后续分配的内存块大小)*/
                unsigned m = sizeof (union header) + n + roundup(10*1024, sizeof (union align));
                ap->next = malloc(m);//将申请的新内存块挂到链表尾部
                ap = ap->next;
                if (ap == NULL) {
                    error("insufficient memory\n");
                    exit(1);
                }
                ap->limit = (char *)ap + m;//置ap->limit
            }//else
        ap->avail = (char *)((union header *)ap + 1);//使avail指向表头struct block字节对齐后的位置
        ap->next = NULL;
        arena[a] = ap;//全局指针移向新的分配区
    }//while
    ap->avail += n;//移动avail，将[avail + avail + n)的n个字节分配出去
    return ap->avail - n;//返回分配的n个字节的起始位置
}
```

显然，`allocate`无法一次性分配超过10KB的内存。
##### 分配区的释放

```C
void deallocate(unsigned a) {
	assert(a < NELEMS(arena));//#define NELEMS(array) ((int)(sizeof(array)/sizeof(array[0])))
	arena[a]->next = freeblocks;//将arena[a]插入至freeblocks表头
	freeblocks = first[a].next;//freeblocks指向arena[a]第一个内存块，至此分配区a的内存块链移入freeblocks表头
	first[a].next = NULL;//头节点与内存块链断开
	arena[a] = &first[a];//尾指针指向头节点
}
```

释放后的分配区`first[a]`如下，

```ditaa {cmd=true args=["-E"] hide=true}
                 +------------------+
                 |                  |
                 v                  |
            +--------+              |
            |  next  |              |
            +--------+         +----+----+
            | avail  |         |arena[a] |
            +--------+         +---------+
            | limit  |
            +--------+
            first[a]
```

### 字符串的存储

`lcc`中将字符串存储在一个字符串的`哈希表`中，每个字符串只保留一个副本，这样可以==通过比较字符串地址来确定字符串是否相等，并且节约了空间==。（哈希表的原理在此不做过多介绍。）

##### 字符串函数

```C
extern char * string(const char *str);//复制从str开始，以'\0'即(null)为结束标志的字符串，返回字符串起始位置
extern char *stringn(const char *str, int len);//复制从str开始的可包括'\0'的字符串的前len个字节，返回字符串起始位置
extern char *stringd(long n);//将整数n转为字符串并返回起始位置
/*3.x版本的声明为stringd(int n)，ANSI C规定long的长度不小于int，
某些环境下int可能只占2个字节而long基本上不少于4字节，选择long尽量支持更大的范围*/
```

`string`、`stringd`均调用了`stringn`。

```C
char *string(const char *str) {
	const char *s;

	for (s = str; *s; s++)
		;//find '\0'
	return stringn(str, s - str);//不包括结束标志'\0'
}

char *stringd(long n) {
	char str[25], *s = str + sizeof (str);
	unsigned long m;

	if (n == LONG_MIN)
		m = (unsigned long)LONG_MAX + 1;//m = 0x80000000;
	else if (n < 0)
		m = -n;
	else
		m = n;
        //m = abs(n); | m = labs(n);
	do
		*--s = m%10 + '0';
	while ((m /= 10) != 0);//每次取得最后一位记录后丢弃
	if (n < 0)
		*--s = '-';//处理符号
	return stringn(s, str + sizeof (str) - s);//从缓冲区中复制结果并返回，同样不包括'\0'
}
/*由于ANSI C允许不同的机器对于负数取模有不同的处理方式，
因此先计算绝对值大小，最后在处理符号。*/
```

经测试发现`stringd`的性能在其使用范围内优于`sprintf`，前者效率约为后者的`3`倍。
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/stringd_sprintf_test_compare.png" alt="stringd_sprintf_test_compare" width="40%">
测试代码如下，
<details>
    <summary>点击展开代码</summary>

```C
#include<time.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

char *stringd(long n, char *dst) {
	char str[25], *s = str + sizeof (str);
	unsigned long m;

	if (n == LONG_MIN)
		m = (unsigned long)LONG_MAX + 1;//m = 0x80000000;
	else if (n < 0)
		m = -n;
	else
		m = n;
        //m = abs(n); | m = labs(n);
	do
		*--s = m%10 + '0';
	while ((m /= 10) != 0);//每次取得最后一位记录后丢弃
	if (n < 0)
		*--s = '-';//处理符号
	return memcpy(dst, s, str + sizeof (str) - s);//从缓冲区中复制结果并返回，同样不包括'\0'
}

char *stringd_sprintf(long n, char *dst) {
	char str[25];
	int len = sprintf(str, "%d", n);
	return memcpy(dst, str, len);//从缓冲区中复制结果并返回，同样不包括'\0'
}

int main() {
	
	clock_t start,end;
	#define TIME_BEGIN 			start = clock();
	#define TIME_END(tip)		{end = clock();printf(#tip" time=%f\n",(double)(end-start)/CLK_TCK);}
	
	
	int i = 0;
	const int TEST_TIMES = 1000000;
	char res[25] = {0};

	for(i = 0;i<TEST_TIMES;i++){
		stringd(i, res);
	}
	TIME_BEGIN
	for(i = 0;i<TEST_TIMES;i++){
		stringd(i, res);
	}
	TIME_END(stringd);
	
	for(i = 0;i<TEST_TIMES;i++){
		stringd_sprintf(i, res);
	}
	TIME_BEGIN
	for(i = 0;i<TEST_TIMES;i++){
		stringd_sprintf(i, res);
	}
	TIME_END(stringd_sprintf);
	
	return ({1; 0;});
}
```

</details>
&emsp;

`lcc`中字符串在数组+链表（拉链法解决冲突）实现的哈希表中管理，具体存储结构如下，

```C
static struct string {
	char *str;
	int len;
	struct string *link;
} *buckets[1024];
```


`stringn`实现了字符串生成（从缓冲区中复制出来），并且检查字符串表中是否存在该字符串，若不存在则把该串加入表中然后返回字符串地址，否则直接返回其地址。
该字符串表采用哈希方法存储字符串，对字符串的每一个字符进行一个随机数表的映射。
对字符进行映射的函数如下,

<details>
<summary>点击展开代码</summary>

```C
static int scatter[] = {	/* map characters to random values */
	2078917053, 143302914, 1027100827, 1953210302, 755253631,
	2002600785, 1405390230, 45248011, 1099951567, 433832350,
	2018585307, 438263339, 813528929, 1703199216, 618906479,
	573714703, 766270699, 275680090, 1510320440, 1583583926,
	1723401032, 1965443329, 1098183682, 1636505764, 980071615,
	1011597961, 643279273, 1315461275, 157584038, 1069844923,
	471560540, 89017443, 1213147837, 1498661368, 2042227746,
	1968401469, 1353778505, 1300134328, 2013649480, 306246424,
	1733966678, 1884751139, 744509763, 400011959, 1440466707,
	1363416242, 973726663, 59253759, 1639096332, 336563455,
	1642837685, 1215013716, 154523136, 593537720, 704035832,
	1134594751, 1605135681, 1347315106, 302572379, 1762719719,
	269676381, 774132919, 1851737163, 1482824219, 125310639,
	1746481261, 1303742040, 1479089144, 899131941, 1169907872,
	1785335569, 485614972, 907175364, 382361684, 885626931,
	200158423, 1745777927, 1859353594, 259412182, 1237390611,
	48433401, 1902249868, 304920680, 202956538, 348303940,
	1008956512, 1337551289, 1953439621, 208787970, 1640123668,
	1568675693, 478464352, 266772940, 1272929208, 1961288571,
	392083579, 871926821, 1117546963, 1871172724, 1771058762,
	139971187, 1509024645, 109190086, 1047146551, 1891386329,
	994817018, 1247304975, 1489680608, 706686964, 1506717157,
	579587572, 755120366, 1261483377, 884508252, 958076904,
	1609787317, 1893464764, 148144545, 1415743291, 2102252735,
	1788268214, 836935336, 433233439, 2055041154, 2109864544,
	247038362, 299641085, 834307717, 1364585325, 23330161,
	457882831, 1504556512, 1532354806, 567072918, 404219416,
	1276257488, 1561889936, 1651524391, 618454448, 121093252,
	1010757900, 1198042020, 876213618, 124757630, 2082550272,
	1834290522, 1734544947, 1828531389, 1982435068, 1002804590,
	1783300476, 1623219634, 1839739926, 69050267, 1530777140,
	1802120822, 316088629, 1830418225, 488944891, 1680673954,
	1853748387, 946827723, 1037746818, 1238619545, 1513900641,
	1441966234, 367393385, 928306929, 946006977, 985847834,
	1049400181, 1956764878, 36406206, 1925613800, 2081522508,
	2118956479, 1612420674, 1668583807, 1800004220, 1447372094,
	523904750, 1435821048, 923108080, 216161028, 1504871315,
	306401572, 2018281851, 1820959944, 2136819798, 359743094,
	1354150250, 1843084537, 1306570817, 244413420, 934220434,
	672987810, 1686379655, 1301613820, 1601294739, 484902984,
	139978006, 503211273, 294184214, 176384212, 281341425,
	228223074, 147857043, 1893762099, 1896806882, 1947861263,
	1193650546, 273227984, 1236198663, 2116758626, 489389012,
	593586330, 275676551, 360187215, 267062626, 265012701,
	719930310, 1621212876, 2108097238, 2026501127, 1865626297,
	894834024, 552005290, 1404522304, 48964196, 5816381,
	1889425288, 188942202, 509027654, 36125855, 365326415,
	790369079, 264348929, 513183458, 536647531, 13672163,
	313561074, 1730298077, 286900147, 1549759737, 1699573055,
	776289160, 2143346068, 1975249606, 1136476375, 262925046,
	92778659, 1856406685, 1884137923, 53392249, 1735424165,
	1602280572
};
```

</details>
&emsp;


```C
char *stringn(const char *str, int len) {
	int i;
	unsigned int h;
	const char *end;
	struct string *p;

	assert(str);
	for (h = 0, i = len, end = str; i > 0; i--)//计算hash值
		h = (h<<1) + scatter[*(unsigned char *)end++];
	h &= NELEMS(buckets)-1;//h = h % (NELEMS(buckets));//确定表中位置
	for (p = buckets[h]; p; p = p->link)
		if (len == p->len) {
			const char *s1 = str;
			char *s2 = p->str;
			do {
				if (s1 == end)
					return p->str;
			} while (*s1++ == *s2++);
		}
	{
		static char *next, *strlimit;
		if (len + 1 >= strlimit - next) {
			int n = len + 4*1024;
			next = allocate(n, PERM);
			strlimit = next + n;
		}
		NEW(p, PERM);
		p->len = len;
		for (p->str = next; str < end; )
			*next++ = *str++;
		*next++ = 0;
		p->link = buckets[h];
		buckets[h] = p;
		return p->str;
	}
}
```



---

## Programming Tips

```C
struct T *p = malloc(sizeof(*p));
//struct T *p = malloc(sizeof(struct T));
```

> 在为指针`p`分配内存时，以`sizeof(*p)`而非`sizeof(struct T)`的形式指明申请的内存字节数。使内存分配不依赖于指针指向的类型，避免`p`的类型发生变化带来的错误。

---

>`sizeof`运算符仅仅计算类型，而不会求值，也就是说`sizeof`的运算数不会产生副作用
```C
sizeof(*(int *)NULL);//equals sizeof(int)
```
PS:`sizeof`是一个运算符而非函数，这意味着上式可以写成
```C
sizeof *(int *)NULL;
```

---

>判断和式的大小时，使用减法代替加法

```
if(ap->avail + n > ap->limit){//bug
    //(ap->avail + n) may overflow
}
//substitution
if(ap->limit - ap->avail < n){
    //...
}
```

---

关于未用宏或常量代替的数值，如`struct string{} *bucket[1024]`。
在一般认识中，为了更好的可读性或者说表意性，
对于此类数值量可用`#define STRING_HT_SIZE 1024`等代替，
而此处仍然使用数值量进行定义，但是在具体使用如计算具体`hash`位置时以`NELEMS(bucket)`代替，预处理后，`NELEMS(bucket)`扩展为`((int)(sizeof (bucket)/sizeof ((bucket)[0])))`在编译期直接计算为`1024`，从而与宏有类似的效率。

---