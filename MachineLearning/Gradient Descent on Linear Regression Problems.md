<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=5 orderedList=false} -->

<!-- code_chunk_output -->

- [Ch.01 Gradient Descent on Linear Regression Problems](#ch01-gradient-descent-on-linear-regression-problems)
    - [模型表示](#模型表示)
    - [代价函数(cost function)](#代价函数cost-function)

<!-- /code_chunk_output -->

# Ch.01 Gradient Descent on Linear Regression Problems

### 模型表示

$ x^{(i)},y^{(i)} $ 分别表示数据集中第 $ i $ 项的输入变量/输入特征，和输出/目标量
e.g.: 房价预测问题中，房子的大小、离市中心的距离等都可作为或共同作为 $ x $，而实际交易的房价为 $ y $

$ (x^{(i)},y^{(i)}) $ 即为训练集中的第 $ i $ 个样本

训练集的大小通常记作 $ m $

$ X, Y$ 也被用来表示输入变量与输出变量的定义域与值域

监督学习的目标是：对于给定的训练集，找到一个函数（映射） $ h: X \to Y $，$ h(x) $ 可以很好的为 $ y $ 做出预测，由于历史原因，$ h(x) $ 通常称为 `hypothesis`，或记为 $ h_\theta $

---

### 代价函数(cost function)

使用`cost function`来衡量`hypothesis`的准确程度。

`cost function` 本质上是一种平均值，它反映了以样本的 $ x $ 作为输入时，$ h(x) $ 与实际的 $ y $ 的误差

对于`linear regression`问题，通常有一个简单实用的代价函数：
$$ J(\theta_0,\theta_1) = \frac{1}{2m}\sum_{i=1}^m(\hat{y_i}-y_i) = \frac{1}{2m}\sum_{i=1}^m(h_\theta(x_i)-y_i)$$