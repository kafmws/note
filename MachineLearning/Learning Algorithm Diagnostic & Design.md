<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=5 orderedList=false} -->

<!-- code_chunk_output -->

- [Learning Algorithm Diagnosis & Design](#learning-algorithm-diagnosis-design)
  - [模型诊断](#模型诊断)
    - [下一步做什么？](#下一步做什么)
    - [假设评估](#假设评估)
    - [模型选择与验证集和测试集](#模型选择与验证集和测试集)
    - [判断欠拟合与过拟合](#判断欠拟合与过拟合)
    - [正规化与拟合](#正规化与拟合)
    - [学习曲线](#学习曲线)
    - [下一步做什么](#下一步做什么-1)
        - [训练策略](#训练策略)
        - [选择模型](#选择模型)
  - [模型设计](#模型设计)
    - [先实现再优化](#先实现再优化)
    - [量化模型评估指标](#量化模型评估指标)
      - [example: 不对称分类误差评估](#example-不对称分类误差评估)
        - [precision 和 recall](#precision-和-recall)
    - [数据集大小的考量](#数据集大小的考量)

<!-- /code_chunk_output -->

# Learning Algorithm Diagnosis & Design

## 模型诊断

### 下一步做什么？
当学习算法在新数据上表现出很大误差，接下来该怎么做？
- 扩大训练集
- 减少特征数量
- 增加额外的特征
- 增加多项式特征（\(x_1^2, x_2^2, x_1x_2,...\)）
- 增大正规化参数\( \lambda \)
- 减小正规化参数\( \lambda \)

### 假设评估
用以下方法确定假设 \(h(\theta)\) 解决问题的效果：

将已有样本划分为**训练集(Training set)**与**测试集(Test set)**（一个常用的比例是7:3，训练集和测试集中的数据应当是无序的），
使用训练集样本最小化代价函数 \(J(\theta)\) 来确定参数 \(\theta\) ，同样地，计算测试集样本的 \(J_{test}(\theta)\) 来评估学习算法的效果。

另外对于`Logistic Regression`问题，可以通过计算`分类错误(misclassification error, 0/1 misclassification error)`评估假设函数

\[ err(h_\theta(x), y) = \left\{
\begin{aligned}
1 \qquad\qquad\qquad &\begin{subarray}{l}
h_\theta(x) \ge 0.5 \  and \  y = 0 \  \\
\qquad\quad or\\
h_\theta(x) \lt 0.5 \  and \  y = 1 \end{subarray}
\\
\\
0 \qquad\qquad\qquad  &otherwise
\end{aligned}
\right.
\\
\ 
\\
TestError = \frac{1}{m_{test}} \sum_{i=1}^{m_{test}}err(h_\theta(x_{test}^{(i)}), y_{test}(i))
\]

（即，正确预测数量/测试集大小

### 模型选择与验证集和测试集
选择多项式次数、所使用的特征、正则化参数等问题称为模型选择

将已有样本划分为**训练集**、**验证集(Validation set, aka Cross Validation set)**和**测试集**。（典型比例6:2:2）
使用训练集拟合假设（确定 $ \theta $），使用验证集进行模型选择（确定特征、正则化参数等模型参数）
最后在测试集上测试所选择的模型的效果

- 验证集
如果用测试集进行模型选择，那么选择出的模型在测试集上的表现不能代表模型的一般表现，因为它就是测试集选择出来、所以适应测试集的。故设置验证集用于模型选择，在测试集上测试得到模型的一般效果。

训练集得到假设在训练集、验证集和测试集上可分别计算出误差 $ J_{train}(\theta), J_{validation}(\theta), J_{test}(\theta)$

\[
  J_{set}(\theta) = \frac{1}{2m_{set}} \sum_{i=1}^{m_{set}} (h_\theta(x^{(i)}) - y^{(i)})^2 \qquad\qquad set = train, validation, test
\]

这些误差可用于判断模型出现的问题。

### 判断欠拟合与过拟合
模型拟合效果存在较大误差，通常存在两种可能：**欠拟合**`(underfitting)`与**过拟合**`(overfitting)`，也表述为 **`bias`** 和 **`variance`** 问题

其中，
- `high bias`即`欠拟合`，表现为`训练集误差(train error)`偏大，模型未能很好地拟合训练集，当然不能有效预测其他样本
==$ high \  J_{train} \quad and \quad high \  J_{CV} $==  ==$ J_{train} \approx J_{CV} $==
- `high variance`即`过拟合`，表现为`训练集误差(train error)`理想，但`验证集误差(cv error)`或`测试集误差(test error)`过大，模型泛化能力差，对于未见过的数据样本缺乏预测能力
==$ high \  J_{CV}/J_{test} $== ==$ \  J_{CV} \gg J_{train} $==

以多项式次数`d`对拟合的影响为例，图示如下：

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/通过误差判断bias&variance.png" alt="通过误差判断bias&variance" width="50%">

而我们需要做的就是，谋求欠拟合`bias`和过拟合`variance`的平衡。

### 正规化与拟合
还有一些模型参数影响拟合效果，如线性回归中的正规化参数 $ \lambda $
$ \lambda $ 过大造成欠拟合，$ \lambda $ 过小无法阻止过拟合

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/regularization and biasvariance.png" alt="regularization and biasvariance" width="70%">

因此，需要用验证集确定合适的正则化参数，同[前一节](#模型选择与验证集和测试集)所描述

一系列正则化参数 $ \lambda $ $ \Longrightarrow $ 学习得到一组不同的 $ \theta $  $ \Longrightarrow $  分别在交叉验证集上计算误差 $ \Longrightarrow $ 取误差最小的对应的 $ \lambda $，在验证集上评估模型的泛化能力

==note==: 计算`误差`的“代价函数”与拟合数据所用的代价函数 $ J $ 不同，前者不会包括正规化项。

### 学习曲线
某些时候，观察算法的学习过程能帮助我们判断算法存在的问题
借助学习曲线来观察学习过程，学习曲线描绘了随训练集大小增加的训练集误差和验证集/测试集误差的变化

- 欠拟合的学习曲线特征：

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/欠拟合的学习曲线示例.png" alt="欠拟合的学习曲线示例" width="50%">

训练集小 ==$ low \  J_{train} \quad and \quad high \  J_{CV} $==

随着训练集增大 ==$ high \  J_{train} \quad and \quad high \  J_{CV} $==  ==$ J_{train} \approx J_{CV} $==

- 过拟合的学习曲线

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/过拟合的学习曲线示例.png" alt="过拟合的学习曲线示例" width="50%">

随着训练集增大，$ J_{train} $ 在增长但仍处于理想情况，$ J_{CV} $ 不断减小但仍然存在较大误差
==$ high \  J_{CV}/J_{test} $== ==$ \  J_{CV} \gg J_{train} $==

**过拟合情况下，增大训练集有助于减小验证集/测试集误差**（训练集接近全集，过拟合接近拟合

### 下一步做什么
当学习算法在新数据上表现出很大误差，接下来该怎么做？

##### 训练策略
以下策略有助于改善算法过拟合情况：
- 扩大训练集
- 减少特征数量
- 增大正规化参数\( \lambda \)

以下策略有助于改善算法欠拟合情况：
- 增加额外的特征
- 增加多项式特征（\(x_1^2, x_2^2, x_1x_2,...\)）
- 减小正规化参数\( \lambda \)

##### 选择模型
（低复杂度/多项式次数）小规模神经网络倾向于欠拟合，同时计算量小；
（高复杂度/多项式次数）大规模神经网络倾向于过拟合，同时计算量大。

## 模型设计

### 先实现再优化
Andrew Ng 认为应该按以下流程设计一个学习算法：
- 快速构建一个可运行的模型，及早地在交叉验证集上测试。**避免过早优化**。
- 通过一些方法如学习曲线确定优化方向，使用当前最有效的手段（更多数据；更多特征；等等）优化模型。
- 检查在交叉验证集中表现出来的错误，分析使模型出错的样本。

### 量化模型评估指标
选择合适的、量化的模型评估指标判断是否应该采取某一策略。

#### example: 不对称分类误差评估
某些情况下，数据集中的样本类别极其不对称。
如预测癌症的模型，数据集中只有约 1% 的样本为阳性，在这种情况下，
如果算法 A 对一切样本均返回 0（阴性），那么算法 A 具有 99% 的`accuracy`。
算法 B 错误地将 0.2% 的阳性样本判定为阴性、2.8% 的阴性判定为阳性，那么算法 B 的`accuracy`为 97%

算法 A 显然不是一个理想的算法，但它在准确率上是优于算法 B 的。因此提出了其他的量化指标来评估模型。

##### precision 和 recall
`precision`和`recall`是更通用的、不受样本类别数量不对称`(skewed classes)`影响的评估指标，定义如下

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/precision&recall definition.png" alt="precision&recall definition" width="50%">

\[
precision = \frac{True\ positive}{True\ positive + False\ positive}
\ \\
\ \\
recall = \frac{True\ positive}{True\ positive + False \ negative}
\]

`precision`和`recall`往往是一对矛盾，`precision`反映了阳性预测的精准程度，`recall`反映了找出所有阳性样本的能力。
比如，在分类问题中提高阳性判定的`threshold`，那么`precision`将会提高，但是`recall`将会下降。
因此定义`F score`（也作F~1~ score）
\[ F score = 2 * \frac{precision * recall}{precision+recall} \]
由此综合两个比较指标，当`precision`和`recall`都比较高时才能获得较高的`F score`

### 数据集大小的考量
实验事实表明，模型复杂到一定程度后（模型能提取的特征能提供足够的信息），训练集约庞大，准确度越高

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/Banko and Brill, 2001的研究.png" alt="Banko and Brill, 2001的研究" width="50%">

上图中，原本`accuracy`相对较低的模型在数据集不断扩大后性能反超
使人不禁产生一种这样的想法：
> “It’s not who has the best algorithm that wins. It’s who has the most data.”

特征是否能提供足够信息的简单测试：人类专家能否通过这些特征自信地做出预测/判断？

2021/10/12