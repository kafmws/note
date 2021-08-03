# simple Octave

`pwd`查看当前工作目录
`cd <path>`改变工作目录 

不等于符号  `~=`

交互式命令中语句末尾添加分号不打印语句结果

`format long`将程序默认小数位数设置为`long`14位，`short`4位

`who`显示当前环境中的变量，`whos`显示更详细的信息

数据I/O：
`load data.dat` `load('data.dat')` `save result.mat ans`
`mat`为`Octave/MATLAB`的数据二进制压缩格式，可存为`txt`为可读格式

`Octave`的第一维是列

---

## 数据计算
矩阵相乘`A * B`，矩阵对应元素相乘`A .* B` `.`表示元素运算
矩阵转置`A', (A')'`

---

## 绘图

为`plot`的图片编号`figure(1)`
绘图`plot(x, y, 'color-shape')`
坐标轴`xlabel('xlabel')` `ylabel('ylabel')`
图例`legend('sin', 'cos')`
标题`title('title')`
叠加图像，后一个`plot`将清空前一个`plot`的图像，使用`hold on`保留当前图像窗口的活跃
`hold off`停止当前图像窗口的活跃
保存文件图片`print -dpng 'myPlot.png'`
关闭图像窗口`close`
在一个窗口绘制多个子图`subplot(grid_size_x, grid_size_y, grid_index)` `grid_index`设置当前在活跃的子图
设置坐标轴范围`axis(xbegin, xend, ybegin, yend)`
清除当前一幅图像`clf`

可视化矩阵`imagesc(A)`彩色图 `colorbar, colormap gray`灰度分布图 

---

## Octave 控制流

==在`Octave`/`MATLAB`中无需对数值进行循环遍历，而是使用向量并行计算==

- 循环
```MATLAB
for i=1:10
    statement...
end

i = 1;
while i <= 5
    statement...
end

% break, continue 都可用于循环语句
```

- 判断
```MATLAB
if logic_statement
    statement...
elseif
    statement...
else
    statement...
end
```

---

- 函数

`Octave`/`MATLAB`和以工作路径和包含路径的方式来引入代码库，然后检索目录下的所有文件

```MATLAB
% 增加检索路径
addpath('/dir/path');

% 或者cd到需要执行代码的路径下
```

```MATLAB
% 可以具有多个返回值
function [re1, re2] = functionName(arg)
    statement...
end
```

