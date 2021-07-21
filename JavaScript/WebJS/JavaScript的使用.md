### JavaScript 在 Web 中的使用

JavaScript 可以直接在 HTML 文档中编写，甚至与 HTML 代码混合，如

```HTML
<button onclick="doSomething()">Press me</button>
<!-- 甚至是直接写入脚本代码 -->
<button onclick="alert('Hello, this is my old-fashioned event handler!');">Press me</button>
```

如果这样，我们需要到 HTML 文档中修改函数调用甚至函数本身。
这不是好的做法，我们最好保持 HTML CSS JavaScript 三者之间的独立。

#### 脚本的加载

HTML 文档外部的 JS 代码通过如下方式加载

```HTML
<script src="js/script.js"></script>
```

当浏览器解析 HTML 文档，遇到`<script>`标签后，暂停 HTML 的解析，加载并执行`<script>`标签中的代码，然后继续 HTML 的解析。

HTML 元素是按其在页面中出现的次序加载的，如果操作页面元素的脚本加载于所操作的元素之前，就会出现错误。
另外一些情况下，一个脚本依赖于另外一个脚本，隐含了脚本的加载/解析次序。

因此需要一定的策略保证脚本的调用次序。

传统的策略是，将脚本元素放在文档体的底端（`</body>`标签之前，与之相邻），保证脚本一定在 HTML 解析完毕后才加载。并且按照脚本的依赖次序编写元素。

##### async 与 defer

另外两种解决方案是使用`async`和`defer`。

`async`的脚本会异步下载，因此不会阻塞页面渲染，下载完成后开始执行（暂停 HTML 解析）。

`defer`的脚本按照在页面中出现的顺序异步加载，并且在 HTML 文档解析完毕后按顺序执行。

因此：

- 如果脚本无需等待页面解析，且相互独立，那么应使用 `async`。
- 如果脚本需要等待页面解析，且依赖于其它脚本，调用这些脚本时应使用`defer`，并按照依赖顺序置于 HTML 中。

#### 事件、冒泡及捕获

事件即事件中的流程节点，如页面加载完成事件，点击事件，键盘事件等。
事件并不是JavaScript的核心部分——它们是在浏览器Web APIs中定义的
`JavaScript`在不同环境下可能使用不同的事件模型

有以下两种方法注册事件处理函数
1. `on*eventname*` 利用`onxxx`属性添加
2. 使用`addEventListener()`和`removeEventListener()`方法
```JavaScript
var btn = document.querySelector('button');

function f() { alert('click'); }

btn.onclick = f;                    // 1
btn.addEventListener('click', f);   // 2
btn.addEventListener('click', function() { alert('another listener'); });

// addEventListener() 可以为同一事件注册多个监听器，而 onxxx 属性会覆盖先前的监听器
// onclick()访问不到addEventListener()注册的事件处理函数
```

事件对象会传递给相应的事件处理函数。
```JavaScript
btn.addEventListener('click', function(e) { console.log(e.target) });
```
传给事件处理函数的第一个参数即为事件对象，其中`target`属性即为触发事件的元素。
事件对象可能携带了属性或数据。

##### 事件的冒泡及捕获
事件传递有两种传递模型：**冒泡**与**捕获**

当一个事件发生在具有父元素的元素上，
**事件捕获**：从最外层祖先元素逐级向触发事件的元素遍历，检查是否注册了捕获阶段的监听函数，若有则执行。
**事件冒泡**：从发生事件的元素逐级向最外层祖先元素遍历，检查是否注册了冒泡阶段的监听函数，若有则执行。

<!-- 图片从Mozilla引用，文章链接 https://developer.mozilla.org/zh-CN/docs/Learn/JavaScript/Building_blocks/Events 图片链接 https://mdn.mozillademos.org/files/14075/bubbling-capturing.png -->
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/事件捕获与事件冒泡.png" alt="事件捕获与事件冒泡" style="clear:both;margin:auto;">


早期浏览器的兼容性比现在要小得多，`Netscape`使用事件捕获，而`Internet Explorer`使用事件冒泡。
现代浏览器对两种传递方式均加以实现，并且**默认使用事件冒泡**。
通过指定第三个参数为`true`即`addEventListener('eventName', function, true)`可以在事件捕获阶段注册监听器。

##### 控制事件的传递
一般情况下，点击内层元素，外层元素所注册的点击事件处理函数也会执行，若需要避免这种情况，
在内层元素事件处理函数中调用事件对象的`stopPropagation()`方法终止事件的传播

##### 阻止默认行为
某些事件具有默认行为，某些时候我们并不想默认行为发生。
如`Web表单`的提交按钮(`<input id="submit" type="submit">`)被点击时，默认提交数据并将浏览器重定向到某个页面，
此时可以在`form`元素的`onsubmit`事件中调用事件对象的`preventDefault()`方法阻止默认行为。
这在表单数据验证中经常用到。

##### 事件委托
当有多个子元素以类似的方式处理事件的时候，可以只为为它们的父级元素添加一个事件处理
如在表格中，为父级元素添加事件处理，使用`e.target`处理实际触发事件的子元素。

这种子元素的事件处理委托给父元素的方法被形象地称为：**事件委托**