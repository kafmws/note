# Memory Management

本章介绍了`lcc`的内存管理——如何分配与回收内存。

#### lcc 的内存管理
```c
struct block{
    struct block *next;
    char *limit;
    char *avail;
};
```



---

```C
struct T *p = malloc(sizeof(*p));
//struct T *p = malloc(sizeof(struct T));
```
> 在为指针`p`分配内存时，以`sizeof(*p)`而非`sizeof(struct T)`的形式指明申请的内存字节数。使内存分配不依赖于指针指向的类型，避免`p`的类型发生变化带来的错误。

---

