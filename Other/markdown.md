## 代码折叠
折叠语法：`<details>` 标签

<details>
    <summary>点击查看详细内容</summary>
    
```C
struct align{
    void *voidp;
    void (*func)();
    char ch;
    double d;
};
```
</details>

&emsp;
上面代码折叠效果所用的代码如下：
```html
<details>
    <summary>点击查看详细内容</summary>
    
\`\`\`C
struct align{
    void *voidp;
    void (*func)();
    char ch;
    double d;
};
\`\`\`
</details>
```
==注意，在VS Code + MPE的渲染环境下，``代码段不能有缩进且上一行必须为空行才能正确渲染==

`details`：折叠语法标签
`summary`：折叠语法展示的摘要
`pre`：以原有格式显示元素内的文字是已经格式化的文本
`code`：指定代码范例
`blockcode`：表示程序的代码块