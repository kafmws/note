
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Chapter2 Exercises](#chapter2-exercises)
        - [2.1](#21)
        - [2.2](#22)
        - [2.3](#23)
        - [2.4](#24)
        - [2.5](#25)
        - [2.6](#26)
        - [2.7](#27)
        - [2.8](#28)
        - [2.9](#29)
        - [2.10](#210)
        - [2.11](#211)
        - [2.12](#212)
        - [2.13](#213)
        - [2.14](#214)
        - [2.15](#215)

<!-- /code_chunk_output -->

# Chapter2 Exercises

##### 2.1 
>使用`C`的库函数`malloc`和`free`修改`allocate`和`deallocate`。

##### 2.2 
>在`lcc`中，如果要在多个算法和设计中进行选择，唯一客观的途径就是实现这些算法和方法，并对其效果进行评测。将`lcc`用于编译其自身的源代码是一种很好的测量标准。请对基于分配区的算法和练习`2.1`所实现的采用`malloc`和`free`的方法的性能进行评测。

##### 2.3 
>重新定义`NEW`，使其尽可能在分配区内部进行分配，即只有当分配区的空间不够时才调用`allocate`。测试其效果。为了实现内部分配方法，必须输出分配区的数据结构。
##### 2.4 
>当`allocate`建立了一个新块时，提供了一个好时机，如果这个新块和该分配区中前一个块相邻，就可以将二者连成一个更大的块，实现并测试这种方法的改进效果。
##### 2.5 
>当`allocate`从`freeblocks`中取走一个块时，有可能这个块太小。对分配程序进行插桩，看看这种情况是否经常发生,这个问题值得修改吗?
##### 2.6 
>说明`deallocate`在分配区列表只有长度为0的块时也能正确工作。
##### 2.7 
>`deallocate`从不真正释放块，如通过调用`free`。在某些输入情况下，`lcc`的分配区会临时膨胀，而已分配的块不会再被利用。修改`deallocate`以释放块，而不是将其加入`freeblocks`中。这种改变能使`lcc`运行得更快吗?
##### 2.8 
>为`lcc`实现一个保守的垃圾收集程序，或者利用一个已有的垃圾收集程序。`Boehm and Weiser (1988)`介绍的收集程序是公开的。大多数这类分配程序在进行分配时会调用收集程序或部分收集程序，因此你可以去掉`deallocate`，或者将其定义为空的宏，并修改`allocate`以调用相应的分配函数。
##### 2.9 
>通过`stringn`在字符串表中建立的字符串不会被删除。这种特点会带来问题吗?调用`stringn`看字符串表的大小分布情况。如果表格太大，如何修改字符串接口，使其允许删除字符串?
##### 2.10 
>`stringd`将其参数格式化成字符串，存入长度为`25`的字符数组`str`中。请解释为什么`25`对于当前`lcc`运行并产生代码的计算机已经足够了。
##### 2.11 
>许多传给`stringd`的整数很小，比如在`-100`到`100`之间。这些整数对应的字符串在编译时就可以进行预分配，`stringd`和`stringn`只要返回指向这些字符串的指针而无须再分配。实现这种优化措施，能使`lcc`运行加快吗？
##### 2.12 
>`stringn`用较大的内存块来存放字符串中的字符，而不会为每个字符串都调用`allocate`。修改`stringn`使得它为每个字符串调用一次`allocate`。比较这两种方法在时间和空间上的差别，并解释这些差别。
##### 2.13 
>`stringn`的哈希表的大小是`2`的幂，这种方法经常遭到反对。尝试将其大小设成某个素数并衡量效果。请设计一种更好的哈希函数并考察其结果。
##### 2.14 
>`stringn`比较字符串采取的是内联代码，而不是调用`memcmp`函数。请用调用`memcmp`代替内联代码。并考察结果。为什么我们要采取内联方法?
##### 2.15 
>`lcc`大量使用了指针循环列表, `list.c`模块的实现可视为使用分配宏`(allocation macro)`的例子，`list.c`输出了列表元素的类型和3个列表操作函数:
```C
typedef struct list *List;

struct list{
    void *x;
    List link;
};

extern List append ARGS((void *x, List list));
extern int length ARGS((List list));
extern void *ltov ARGS((List *list, unsigned a));
```
>`List`保存了`0`或多个元素，每个元素存放在`list`结构的`x`域中。`List`指向列表中最后一个`list`结构,空的`List`定义为空列表。`append`函数把包含`x`的节点加入`list`列表的末尾并返回`list`。`length`函数返回列表中元素的数目。`ltov`函数把 `list`中的`n`个元素复制到`a`所指的分配区中以空元素结尾的指针数组，释放列表结构并返回该数组。数组中有`n+1`个元素，包含一个空元素。请实现这种列表模块。

==解答==：
函数实现如下，
```C
static List freenodes;

List append(void *x, List list) {
  List new;
  if (new = freenodes)
    freenodes = freenodes->link;
  else
    NEW(new, PERM);
  new->x = x;
  List head = new;
  if (list) {
    head = list->link;
    list->link = new;
  }
  new->link = head;
  return new;
}

int length(List list) {
  if (list == NULL)
    return 0;
  int len = 1;
  List p = list;
  while ((p = p->link) && p != list) {
    len++;
  }
  return len;
}

void *ltov(List *list, unsigned a) { // list to vector
  /*没有边遍历边释放结点边申请单个元素空间复制元素是因为，
  没法保证连续allocate得到的多个空间是连续的，如字节对齐*/
  assert(list);
  assert(*list);

  List pre, p = (*list)->link; // p->head of list
  int len = length(p) + 1;
  void **arr = newarray(len, sizeof(*arr), a);
  int cnt = 0;
  do {
    arr[cnt++] = p->x;
    pre = p;
    p = p->link;
    pre->link = freenodes;
    freenodes = pre;
  } while (pre != *list);
  arr[cnt] = NULL;
  *list = NULL;
  return arr;
}
```
测试程序如下，
<details>
   <summary>点击展开代码</summary>

```C
#include "test.h"
#include "c.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

struct block {
  struct block *next;
  char *limit;
  char *avail;
};
union align {
  long l;
  char *p;
  double d;
  int (*f)(void);
};
union header {
  struct block b;
  union align a;
};

static struct block first[] = {{NULL}, {NULL}, {NULL}},
                    *arena[] = {&first[0], &first[1], &first[2]};
static struct block *freeblocks;

void *allocate(unsigned long n, unsigned a) {
  struct block *ap;

  assert(a < NELEMS(arena));
  assert(n > 0);
  ap = arena[a];
  n = roundup(n, sizeof(union align));
  while (n > ap->limit - ap->avail) {
    if ((ap->next = freeblocks) != NULL) {
      freeblocks = freeblocks->next;
      ap = ap->next;
    } else {
      unsigned m =
          sizeof(union header) + n + roundup(10 * 1024, sizeof(union align));
      ap->next = malloc(m);
      ap = ap->next;
      if (ap == NULL) {
        perror("insufficient memory\n");
        exit(1);
      }
      ap->limit = (char *)ap + m;
    }
    ap->avail = (char *)((union header *)ap + 1);
    ap->next = NULL;
    arena[a] = ap;
  }
  ap->avail += n;
  return ap->avail - n;
}

void *newarray(unsigned long m, unsigned long n, unsigned a) {
  return allocate(m * n, a);
}
void deallocate(unsigned a) {
  assert(a < NELEMS(arena));
  arena[a]->next = freeblocks;
  freeblocks = first[a].next;
  first[a].next = NULL;
  arena[a] = &first[a];
}

#define PERM 0

typedef struct list *List;

struct list {
  void *x;
  List link;
};

extern List append(void *x, List list);
extern int length(List list);
extern void *lotv(List *list, unsigned a);

static List freenodes;

List append(void *x, List list) {
  List new;
  if (new = freenodes)
    freenodes = freenodes->link;
  else
    NEW(new, PERM);
  new->x = x;
  List head = new;
  if (list) {
    head = list->link;
    list->link = new;
  }
  new->link = head;
  return new;
}

int length(List list) {
  if (list == NULL)
    return 0;
  int len = 1;
  List p = list;
  while ((p = p->link) && p != list) {
    len++;
  }
  return len;
}

void *ltov(List *list, unsigned a) { // list to vector
  /*没有边遍历边释放结点边申请单个元素空间复制元素是因为，
  没法保证连续allocate得到的多个空间是连续的，如字节对齐*/
  assert(list);
  assert(*list);

  List pre, p = (*list)->link; // p->head of list
  int len = length(p) + 1;
  void **arr = newarray(len, sizeof(*arr), a);
  int cnt = 0;
  do {
    arr[cnt++] = p->x;
    pre = p;
    p = p->link;
    pre->link = freenodes;
    freenodes = pre;
  } while (pre != *list);
  arr[cnt] = NULL;
  *list = NULL;
  return arr;
}

int main() {
  int TESTNUM = 10;

  List list = NULL;
  int test_num[100] = {0}, *num_addr[100] = {0}, i;
  for (i = 0; i < TESTNUM; i++) {
    test_num[i] = i;
    num_addr[i] = &test_num[i];
    EXPECT_EQ_INT(i, length(list));
    list = append(&test_num[i], list);
  }
  int **num = ltov(&list, PERM);
  EXPECT_TRUE(list == NULL);
  EXPECT_TRUE(length(freenodes) == 10);
  EXPECT_EQ_ARRAY((int **)num_addr, num, TESTNUM, "%p");
  for (i = 0; i < TESTNUM; i++) {
    list = append(&test_num[i], list);
  }
  EXPECT_TRUE(freenodes == NULL);
  return MAIN_RET;
}

```
</details
&emsp;>