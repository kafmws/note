<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=5 orderedList=false} -->

<!-- code_chunk_output -->

- [Ch.02 Gradient Descent on Linear Regression Problems](#ch02-gradient-descent-on-linear-regression-problems)
  - [1. 单元梯度下降](#1-单元梯度下降)
    - [1.1 线性回归(Linear Regression)](#11-线性回归linear-regression)
    - [1.2 模型表示](#12-模型表示)
    - [1.3 代价函数(cost function)](#13-代价函数cost-function)
      - [1.3.1 代价函数的图形表示](#131-代价函数的图形表示)
    - [1.4 梯度下降(Gradient Descent)](#14-梯度下降gradient-descent)
      - [1.4.1 学习率(learning rate)](#141-学习率learning-rate)
      - [1.4.2 同步更新(simultaneous update)](#142-同步更新simultaneous-update)
    - [1.5 线性回归中的梯度下降](#15-线性回归中的梯度下降)
    - [1.6 不同的梯度下降算法](#16-不同的梯度下降算法)
  - [2. 多元梯度下降](#2-多元梯度下降)
    - [2.1 单变量梯度下降推广](#21-单变量梯度下降推广)
    - [2.2 多元梯度下降的优化](#22-多元梯度下降的优化)
      - [2.2.1 特征缩放(Feature Scaling)](#221-特征缩放feature-scaling)
      - [2.2.2 均值归一化(mean normalization)](#222-均值归一化mean-normalization)
    - [2.3 梯度下降效果的检验与学习率的选择](#23-梯度下降效果的检验与学习率的选择)
      - [2.3.1 梯度下降效果的检验](#231-梯度下降效果的检验)
      - [2.3.2 学习率 $ \alpha $ 的选择](#232-学习率-alpha-的选择)
  - [2.4 多项式回归中的特征](#24-多项式回归中的特征)
  - [3. 最小化代价函数的正规方程解法](#3-最小化代价函数的正规方程解法)
    - [3.1 正规方程求解参数 $ \theta $](#31-正规方程求解参数-theta)
    - [3.2 梯度下降与正规方程的比较](#32-梯度下降与正规方程的比较)
    - [3.3 正规方程的不可逆情况](#33-正规方程的不可逆情况)

<!-- /code_chunk_output -->

# Ch.02 Gradient Descent on Linear Regression Problems

## 1. 单元梯度下降

本节中有一些共同部分与[多元梯度下降](#多元梯度下降)一节共享

### 1.1 线性回归(Linear Regression)

回归，即使用一条曲线拟合数据，从而根据输入变量预测结果
线性回归即回归方程的**系数均为线性**
线性回归问题要确定回归方程的各个系数从而得到回归方程，这实际上是一个求解最小值（使回归方程与数据样本的距离最小）的问题；
在`Machine Learning`中，线性回归是一类监督学习问题

### 1.2 模型表示

$ x^{(i)},y^{(i)} $ 分别表示数据集中第 $ i $ 项的输入变量/输入特征，和输出/目标量
e.g.: 房价预测问题中，房子的大小、离市中心的距离等都可作为或共同作为 $ x $，而实际交易的房价为 $ y $

$ (x^{(i)},y^{(i)}) $ 即为训练集中的第 $ i $ 个样本

训练集的大小通常记作 $ m $ ，即样本容量
$ X, Y$ 用来表示输入变量与输出变量的定义域与值域

监督学习的目标是：对于给定的训练集，找到一个函数（映射） $ h: X \to Y $，$ h(x) $ 即为根据 $ x $ 预测 $ y $ 的模型

在`Linear Regression`问题中使用线性函数拟合数据时，$ h_\theta $ 常被定义为

\[
h(x) = \theta_0 + \theta_1x
\]

在更一般的情形中， $ h(x) $ 可表示为

\[
h(x) = \theta_0 + \theta_1x_1 + \theta_2x_2 + \cdots + \theta_nx_n
\]

由于历史原因，$ h(x) $ 通常称为 `hypothesis`，或记为 $ h_\theta $、$ h $ 等

选择了某种形式的 $ h_\theta(x) $ 后需要确定各个 $ \theta $ 参数，得到拟合数据的函数

---

### 1.3 代价函数(cost function)

使用`cost function`来衡量`hypothesis`的准确程度
`Cost function` 本质上是一种平均值，它计算了以样本的 $ x $ 作为输入时，$ h(x) $ 与实际 $ y $ 的平均误差
因此可以反映 $ h_\theta $ 的好坏程度，也可通过求解代价函数的最小值寻找拟合数据最准确的 $ h_\theta $

当使用线性函数 $ h(x) = \theta_0 + \theta_1x $ 拟合数据时，通常有一个简单实用的代价函数：

\[
J(\theta_0,\theta_1) = \frac{1}{2m}\sum_{i=1}^m {(\hat{y_i}-y_i)}^2 = \frac{1}{2m}\sum_{i=1}^m {(h_\theta(x_i)-y_i)}^2
\]

显然，`cost function` $ J $ 只是收集了 $ h_\theta $ 与实际值误差的平方和与并做了平均

（平方操作也使得每个 $ h_\theta(x^{(i)}) $ 与真实值 $ y^{(i)} $ 的误差非负，符合`距离`意义，也即 $ J(\theta_0,\theta_1) \ge 0$）
（ $\frac{1}{m}$ 乘以 $\frac{1}{2}$ 仅仅为了约去后面求导产生的系数 $ 2 $ 以简化计算，这只会改变函数在纵向轴的高度，而不改变形状及最优解）

推论：

\[
J(\theta) = 0 \quad \Rightarrow \quad h_\theta(x^{(i)}) \equiv y^{(i)}
\qquad\qquad
(i = 1,2,3...m)
\]

代价函数也被称为平均误差函数(`Squared error function`)、均方误差(`Mean squared error`)

由此，$ J(\theta_0,\theta_1) $ 越小，$ h_\theta $ 与训练集的样本就越接近，即可通过寻找 $ J_{\min}(\theta_0,\theta_1) $ 来确定 $ h_\theta $

#### 1.3.1 代价函数的图形表示
函数图像可以直观反映出函数值，对于更简单的情形，如： $ h(x) = \theta_1x $
$ J(\theta_1) $ 可能是类似下面的形状

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/J(θ)示例.png" alt="J(θ)示例" width="30%">

可以清楚看出 $ \theta $ 的不同取值对应的代价大小

当 $ h(x) = \theta_0 + \theta_1x $ 即 $ J(\theta) $ 为二元函数时，函数图像是三维的
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/两参数代价函数示例图像.png" alt="两参数代价函数示例图像" width="40%">
三维函数图像经常使用等高图(`contour plot`)表示，类似地理学中的等高线
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/等高图示例.png" alt="等高图示例" width="40%">
其中，同色线表示参数取值对应的函数值相等，此时相对于每一点函数值的绝对大小我们更关注相对大小

借助代价函数及其图像，我们可以估计`hypothesis`中的参数取值，使用梯度下降(`Gradient Descent`)算法确定 $ \theta $ 的取值是一种常用手段

---

### 1.4 梯度下降(Gradient Descent)

**沿梯度的反方向减小函数值**，这是梯度下降的基本思想

为了尽快从 $ J_\theta $ 上任意一点出发到达 $ J_{\min} $ ，得到拟合数据效果最好的 $ h_\theta $
我们需要向函数值减小最快的方向（梯度反方向）移动

> 梯度即坐标轴方向的方向导数组成的向量，该向量方向即是函数在该点变化最快、变化率最大的方向。同理，其反方向也即函数减小最快的方向
 $ \quad\,\, $ 若 $ z = f(x,y) $ 在平面 $ \mathrm{D} $ 上具有一阶连续偏导，点 $ p \in \mathrm{D} $ ，则点 $ p $ 的梯度 $ \nabla $ 计算为
 \[
 \nabla = \frac{\partial f}{\partial x}\vec{i} + \frac{\partial f}{\partial y}\vec{j}
 \]

或者
> 函数值的变化可以分解为表示参数的坐标轴方向上的变化
因此，确定在各坐标轴上的减小方向即确定了代价下降最快的方向（也是 $ \theta $ 们的变化方向）
> 
> 而坐标轴方向上函数值的变化趋势通过斜率（导数，`derivative`）的正负反映出来
> - 当前点在某方向上导数大于0，函数值在该方向上增加，应当选择反方向
> - 斜率小于0时，函数值在该方向上减少，应当选择该方向

梯度下降使代价函数 $ J(\theta) $ 的自变量（即 $ h_\theta $ 的参数）不断向函数值下降最快的方向移动，最终到达 $ J_{\min} $ 

由此，梯度下降算法如下：

从函数 $ J $ 上任意一点开始，重复下述过程直到到达 $ J_{\min} $ 
- 计算当前位置下降最快的方向并向该方向移动若干距离

即

\[
{\theta}_j = {\theta}_j - \alpha\frac{\partial}{\partial \theta_0}J(\theta_0, \theta_1, \theta_2 \cdots  \theta_n)
\qquad\qquad
(j = 0,1,2...n)
\]

上式中被减去的偏导项即各坐标轴方向上的导数，即每个参数 $ \theta $ 向函数值减小的方向变化

函数值收敛到 $ J_{\min} $ 后，各方向导数均为 $ 0 $ ， $ \theta $ 不再变化，这一点可以作为算法的终止条件

对样本数据来说， $ h_\theta $ 在每一次迭代后都变得更加准确，下图中除起始位置外每一个星号表示一次迭代(下降)的落脚点

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/梯度下降过程示例.png" alt="梯度下降过程示例" width="60%">

#### 1.4.1 学习率(learning rate)

在上式中系数 $ \alpha $ 称为==学习率==，它影响每次向 $ J_{\min} $ 移动的步伐大小
 $ \alpha $ 选取较大则算法迭代次数较少，$ \alpha $ 选取较小则算法迭代次数较多，此外
- $ \alpha $ 设置过大可能导致最小值被跨过，代价不减反升，甚至导致迭代过程发散，无法收敛至 $ J_{\min} $ 
- $ \alpha $ 设置过小会使算法迭代次数过多，导致性能问题

因此， $ \alpha $ 需要设置为一个合理的值，数学表明，若 $ \alpha $ 足够小， 在每次迭代中 $ J(\theta) $ 一定是递减的

此外，即使 $ \alpha $ 是一个固定的值，每次迭代的移动步长也会随着斜率减小而减小，从而到达极小值点

#### 1.4.2 同步更新(simultaneous update)

梯度下降算法中，所有 $ \theta $ 参数需要==同步更新==
即在当前位置计算出所有新的 $ \theta $ 后再一起更新；在同一轮 $ \theta $ 的计算中，不能使用刚计算出的 $ \theta_j $ 计算 $ \theta_{j+1} $ 的值
> 用当前坐标完整计算出下一个坐标后，同时更新坐标每个分量，而非逐步更新坐标的各个分量
> 使用 $ ( \theta_0, \theta_1, \cdots \theta_n) $ 计算出 $ ( \theta_0', \theta_1', \cdots \theta_n') $ ，再用后者做下一轮迭代，而非计算出 $ \theta_0' $ 后用 $ ( \theta_0', \theta_1, \cdots \theta_n) $ 计算 $ \theta_1' $ 

- 应用示例

以一个线性回归问题为例，若假设函数为 $ h(x) = \theta_0 + \theta_1x $，代价函数为 $ J(\theta_0, \theta_1) = \dfrac{1}{2m} \sum\limits_{i=1}^{m}(h(x^{(i)}) - y^{(i)})^2 $
则对应的梯度下降过程为：

\(
  \begin{aligned}
   \text{repeat until convergence: }& \lbrace \newline \theta_0 &:= \theta_0 - \alpha \frac{1}{m} \sum\limits_{i=1}^{m}(h_\theta(x^{(i)}) - y^{(i)}) \newline \theta_1 &:= \theta_1 - \alpha \frac{1}{m} \sum\limits_{i=1}^{m}(h_\theta(x^{(i)}) - y^{(i)}) \cdot x^{(i)} \newline &\rbrace
  \end{aligned}
\)

收敛后得到的 $ \theta_0, \theta_1 $ 即为拟合数据代价最小的 $ h(x) $ ，给定一个输入 $ x $，即可由 $ h(x) $ 给出一个预测结果

---

### 1.5 线性回归中的梯度下降

结论：
&emsp;&emsp;所有线性回归问题中代价函数的图像一定是碗状的（凸的二次函数），这意味着线性回归问题中梯度下降算法得到的最小值一定是全局最小值，并且不存在其它局部最小值

对于更一般的函数，梯度下降收敛到某个局部最小值，也就是说，算法中初始位置不同可能导致结果不同

> 关于凸函数(`convex function`)
国内外或不同层次领域对凸函数的定义可能不同，此处凸函数定义为二阶导数大于0

---

### 1.6 不同的梯度下降算法

在上述的梯度下降算法中，每次迭代我们都遍历了一遍训练集中的所有数据，这种梯度下降称为`Batch gradient descent`.

某些梯度下降算法每次迭代仅遍历样本数据得一个子集

---

## 2. 多元梯度下降

### 2.1 单变量梯度下降推广

使用 $ n $ 表示特征数量
使用 $ x^{(i)}_j $ 表示第 $ i $ 个样本的第 $ j $ 个特征

多元梯度下降的一般形式可以表示为

\[
h_\theta(x) = \theta_0 + \theta_1x_1 + \theta_2x_2 + \cdots + \theta_nx_n
\]

亦即

\[
h_\theta(x) = \begin{bmatrix} \theta_0 \theta_1 \cdots \theta_n \end{bmatrix}
\begin{bmatrix}
  x_0 \\ x_1 \\ \vdots \\ x_n
\end{bmatrix} = \theta^Tx
\]

其中， $ x_0 \equiv 1 $ .

此时代价函数为

\[
J(\theta_0,\theta_1 \cdots \theta_j) = \frac{1}{2m}\sum_{i=1}^m {(h_\theta(x^{(i)})-y^{(i)})}^2
\]

同理，单变量的梯度下降算法可以容易地推广到多元情况

\[
  \begin{aligned}
   \text{repeat until convergence: }& \lbrace \\
   \theta_j &:= \theta_j - \alpha \frac{1}{m} \sum\limits_{i=1}^{m} (h_\theta(x^{(i)}) - y^{(i)}) \cdot x_j^{(i)} \qquad\qquad (j = 0,1,2...n) \\
   &\rbrace
  \end{aligned}
\]

### 2.2 多元梯度下降的优化

#### 2.2.1 特征缩放(Feature Scaling)

==使所有特征处于相近的数量级==

当存在多个特征时，特征变量可能处于不同的数量级，这可能造成梯度下降迭代次数过多而导致性能问题

以两个特征 $ x_1 \in [100,999], x_2 \in [1,9] $ 为例
- 若学习率 $ \alpha $ 适用于特征 $ x_1 $ 的数量级而设置相对小，每次迭代使 $ \theta_1 $ 改变量为 $ \Delta\theta $ ，则参数 $ \theta_2 $ 的变化量约为 $ \frac{\Delta\theta}{100} $ ，这个值太小而不利于在 $ \theta_2 $ 方向上下降，每次迭代 $ J(\theta) $ 的变化类似于下图
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/未特征缩放产生的性能问题示例1.png" alt="未特征缩放产生的性能问题示例1" width="50%">

- 若学习率 $ \alpha $ 适用于特征 $ x_2 $ 的数量级而设置相对大，每次迭代使 $ \theta_2 $ 改变量为 $ \Delta\theta $ ，则参数 $ \theta_1 $ 的变化量约为 $ 100 \cdot  \Delta\theta $ ，这个值太大可能使代价函数在 $ \theta_1 $ 方向来回越过最优值，每次迭代 $ J(\theta) $ 的变化类似于下图
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/未特征缩放产生的性能问题示例2.png" alt="未特征缩放产生的性能问题示例2" width="50%">

比较理想的情况是特征的取值在同一数量级或处于相近范围，`特征缩放`是一种有效的方法，`特征缩放`将特征 $ x $ 除以其取值范围（注意，**此处的取值范围具有实际意义的取值范围，而是数据集中的最值之差**），即 $ x_i = \frac{x_i}{x_{\max} - x_{\min}} $ ，**特征取值范围将被约束至 $ [-1,1] $ 内**
如特征为`面积(平方米)`，取值范围 $ [0, 1000] $，则替换为`面积(千平方米)`，取值范围 $ [0, 1] $

#### 2.2.2 均值归一化(mean normalization)

`均值归一化`使特征的均值接近于 $ 0 $ ，得到一个相对对称的取值区间
具体做法是使特征减去其均值（**数据集中该特征的平均值**），即使用 $ x_i - \mu_i $ 替换 $ x_i $ ，其中 $ \mu_i $ 为特征 $ x_i $ 的均值

两种方法结合起来即为 $ x_i = \dfrac{x_i - \mu_i}{s_i} $ ，其中 $ {s_i} $ 为 $ x_{max} - x_{min} $ 或`标准差(standard deviation)`
通过特征缩放和均值归一化可以显著减少梯度下降的迭代次数，从而加快梯度下降算法

### 2.3 梯度下降效果的检验与学习率的选择

#### 2.3.1 梯度下降效果的检验

以迭代次数为横坐标， $ J(\theta) $ 为纵坐标绘图，图像应与下图类似

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/J(θ)随迭代次数递减示意图.png" alt="J(θ)随迭代次数递减示意图" width="40%">

曲线趋近于水平时 $ J(\theta) $ 接近收敛，例如当某次迭代后 $ \Delta J(\theta) < 10^{-3} $ 时认为已到达结果

#### 2.3.2 学习率 $ \alpha $ 的选择

若 $ J(\theta) - numbers \ \ of \ \ iterations $ 图像呈现为递增或递减后递增等情形，一般情况下需要减小 $ \alpha $ 

仍然需留意， $ \alpha $ 取值过小会使迭代次数增多产生性能问题； $ \alpha $ 取值过大代价可能不减反增且无法收敛；可设定一定序列如 $ 0.01, 0.1, 1 $ 等进行尝试，并最终尽可能大地选择学习率

## 2.4 多项式回归中的特征

实际上，特征不一定是简单原始的量，可以通过已有的特征组合出新特征，如物体的长和宽可以组合出面积特征

同时，依据对函数图像地了解，可以通过二次项、三次项、平方根项等形式改变`hypothesis`来更好地拟合数据

例如，当使用 $ h_\theta(x) = \theta_0 + \theta_1 x_1 $ 拟合下图的数据时，

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/多项式拟合数据示例.png" alt="多项式拟合数据示例" width="50%">

若选择绿色线（三次函数）进行拟合，则假设函数可以设定为以下形式

\[
  h_\theta(x) = \theta_0 + \theta_1 x_1 + \theta_2 x_2 + \theta_3 x_3 \qquad\qquad (x_1 = size, \ x_2 = size^2, \ x_3 = size^3)
\]

若选择蓝色线（含有二分之一次方的多项式）进行拟合，则假设函数可以设定为以下形式

\[
  h_\theta(x) = \theta_0 + \theta_1 x_1 + \theta_2 x_2 \qquad\qquad (x_1 = size, \ x_2 = \sqrt{size})
\]

如此形式，进行线性回归

此外需要注意，==当对特征进行变换作为新的特征时，应适当使用特征缩放==，此时新特征的数量级可能和原有特征差别很大

---

## 3. 最小化代价函数的正规方程解法

### 3.1 正规方程求解参数 $ \theta $

设矩阵 $ X_{m×n} $ 表示 $ m $ 个样本的 $ n $ 个特征变量输入(包括对待 $ \theta_0 $ 的 $ 1 $ )， $ y $ 为样本的实际值
则有

\[
  X \theta = y \  \Rightarrow \  \theta = (X^TX)^{-1}X^T y
\]

即通过解正规方程计算出 $ \theta $ 向量

### 3.2 梯度下降与正规方程的比较

| 梯度下降 | 正规方程|
|:-----:|:-----:|
需要选取恰当的学习率 | 无需选择学习率
迭代算法 | 非迭代算法
$ O(kn^2) $ | $ O (n^3) $ ，计算 $ (X^TX)^{-1} $
特征变量个数 $ n $ 可以很大| n 太大(约 $ 10,000 $ )时矩阵求解过慢
进行`特征缩放`可以提升效率 | 无需`特征缩放`

### 3.3 正规方程的不可逆情况

对于公式 $ \theta = (X^TX)^{-1}X^T y $ ， $ (X^TX)^{-1} $ 不一定总是存在，然而大多数线性代数库会提供求解伪逆的方法
如 `Octave/MATLAB` 中的 `pinv()` 函数返回一个近似的逆矩阵
从而可以得到 $ \theta $ 的近似值，逼近 $ J(\theta) $ 的最小值，使正规方程解法在工程上具有可能性

此外，以下原因通常会导致矩阵 $ X^TX $ 不可逆：
- 冗余特征，特征变量中存在线性关系
- 特征过多，如 $ m \lt n $ 时 (原讲义 $ m \le n $ )

分别以 删去冗余特征、减少特征的个数或进行正规化 的方法进行处理

2021/8/10