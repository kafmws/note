<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=5 orderedList=false} -->

<!-- code_chunk_output -->

- [Ch.02 Gradient Descent on Linear Regression Problems](#ch02-gradient-descent-on-linear-regression-problems)
    - [线性回归(Linear Regression)](#线性回归linear-regression)
    - [模型表示](#模型表示)
    - [代价函数(Cost function)](#代价函数cost-function)
      - [代价函数的图形表示](#代价函数的图形表示)
    - [梯度下降(Gradient Descent)](#梯度下降gradient-descent)
      - [学习率](#学习率)
      - [同步更新](#同步更新)

<!-- /code_chunk_output -->

# Ch.02 Gradient Descent on Linear Regression Problems

### 线性回归(Linear Regression)
回归，即使用一条曲线拟合数据，从而根据输入变量预测结果
线性回归即回归方程的**系数均为线性**
线性回归问题要确定回归方程的各个系数从而得到回归方程，这实际上是一个求解最小值（使回归方程与数据样本的距离最小）的问题；
在`Machine Learning`中，线性回归是一类监督学习问题

### 模型表示

$ x^{(i)},y^{(i)} $ 分别表示数据集中第 $ i $ 项的输入变量/输入特征，和输出/目标量
e.g.: 房价预测问题中，房子的大小、离市中心的距离等都可作为或共同作为 $ x $，而实际交易的房价为 $ y $

$ (x^{(i)},y^{(i)}) $ 即为训练集中的第 $ i $ 个样本

训练集的大小通常记作 $ m $ ，即样本容量
$ X, Y$ 用来表示输入变量与输出变量的定义域与值域

监督学习的目标是：对于给定的训练集，找到一个函数（映射） $ h: X \to Y $，$ h(x) $ 即为根据 $ x $ 预测 $ y $ 的模型

在`Linear Regression`问题中使用线性函数拟合数据时，$ h_\theta $ 常被定义为
$$ h(x) = \theta_0 + \theta_1x $$在更一般的情形中，$ h(x) $ 可表示为 $$  h(x) = \theta_0 + \theta_1x + \theta_2x^2 + \cdots + \theta_nx^n $$由于历史原因，$ h(x) $ 通常称为 `hypothesis`，或记为 $ h_\theta $、$ h $ 等

选择了某种形式的 $ h_\theta(x) $ 后需要确定各个 $ \theta $ 参数，得到拟合数据的函数

---

### 代价函数(Cost function)

使用`cost function`来衡量`hypothesis`的准确程度
`Cost function` 本质上是一种平均值，它计算了以样本的 $ x $ 作为输入时，$ h(x) $ 与实际 $ y $ 的平均误差
因此可以反映 $ h_\theta $ 的好坏程度，也可通过求解代价函数的最小值寻找拟合数据最准确的 $ h_\theta $

当使用线性函数 $ h(x) = \theta_0 + \theta_1x $ 拟合数据时，通常有一个简单实用的代价函数：
$$ J(\theta_0,\theta_1) = \frac{1}{2m}\sum_{i=1}^m {(\hat{y_i}-y_i)}^2 = \frac{1}{2m}\sum_{i=1}^m {(h_\theta(x_i)-y_i)}^2 $$

显然，`cost function` $ J $ 只是收集了 $ h_\theta $ 与实际值误差的平方和与并做了平均

（平方操作也使得每个 $ h_\theta(x^{(i)}) $ 与真实值 $ y^{(i)} $ 的误差非负，符合`距离`意义，也即 $ J(\theta_0,\theta_1) \ge 0$）
（ $\frac{1}{m}$ 乘以 $\frac{1}{2}$ 仅仅为了约去后面求导产生的系数 $ 2 $ 以简化计算，这只会改变函数在纵向轴的高度，而不改变形状及最优解）

推论：
$$
J(\theta) = 0 \quad \Rightarrow \quad h_\theta(x^{(i)}) \equiv y^{(i)}
\qquad\qquad
(i = 0,1,2...m)
$$

代价函数也被称为平均误差函数(`Squared error function`)、均方误差(`Mean squared error`)

由此，$ J(\theta_0,\theta_1) $ 越小，$ h_\theta $ 与训练集的样本就越接近，即可通过寻找 $ J_{\min}(\theta_0,\theta_1) $ 来确定 $ h_\theta $

#### 代价函数的图形表示
函数图像可以直观反映出函数值，对于更简单的情形，如： $ h(x) = \theta_1x $
$ J(\theta_1) $ 可能是类似下面的形状
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/J(θ)示例.png" alt="J(θ)示例" style="clear:both;display:block;margin:auto;" width="60%">
可以清楚看出 $ \theta $ 的不同取值对应的代价大小

当 $ h(x) = \theta_0 + \theta_1x $ 即 $ J(\theta) $ 为二元函数时，函数图像是三维的
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/两参数代价函数示例图像.png" alt="两参数代价函数示例图像" width="50%">
三维函数图像经常使用等高图(`contour plot`)表示，类似地理学中的等高线
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/等高图示例.png" alt="等高图示例" width="50%">
其中，同色线表示参数取值对应的函数值相等，此时相对于每一点函数值的绝对大小我们更关注相对大小

借助代价函数及其图像，我们估计`hypothesis`中的参数取值，梯度下降`Gradient Descent`是一种常用手段

---

### 梯度下降(Gradient Descent)

**沿梯度的反方向减小函数值**，这是梯度下降的基本思想

为了尽快从 $ J_\theta $ 上任意一点出发到达 $ J_{\min} $ ，得到拟合数据效果最好的 $ h_\theta $
我们需要向函数值减小最快的方向（梯度反方向）移动

> 梯度即坐标轴方向的方向导数组成的向量，该向量方向即是函数在该点变化最快、变化率最大的方向。同理，其反方向也即函数减小最快的方向
 $ \quad\,\, $ 若$ z = f(x,y) $ 在平面 $ \mathrm{D} $ 上具有一阶连续偏导，点 $ p \in \mathrm{D} $ ，则点 $ p $ 的梯度 $ \nabla $ 计算为
 $$ \nabla = \frac{\partial f}{\partial x}\vec{i} + \frac{\partial f}{\partial y}\vec{j}$$

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

$$
{\theta}_i = {\theta}_i - \alpha\frac{\partial}{\partial \theta_0}J(\theta_0, \theta_1, \theta_2 \cdots  \theta_n)
\qquad\qquad
(i = 0,1,2...n)
$$

上式中被减去的偏导项即各坐标轴方向上的导数，即每个自变量向函数值减小的方向变化

#### 学习率
在上式中系数 $ \alpha $ 称为==学习率==，它决定了每次向 $ J_{\min} $ 移动的步伐大小
 $ \alpha $ 选取较大则算法迭代次数较少，$ \alpha $ 选取较小则算法迭代次数较多，此外
- $ \alpha $ 设置过大可能导致最小值被跨过，代价不减反升，甚至导致迭代过程发散，无法收敛至 $ J_{\min} $ 
- $ \alpha $ 设置过小会使算法迭代次数过多，导致性能问题

==达到 $ J_{\min} $ 后，各方向上导数均为0，==
#### 同步更新