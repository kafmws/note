<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=5 orderedList=false} -->

<!-- code_chunk_output -->

- [Support Vector Machine](#support-vector-machine)
  - [从 Logistic Classification 到 SVM](#从-logistic-classification-到-svm)

<!-- /code_chunk_output -->

# Support Vector Machine

支持向量机(`Support Vector Machine(SVM)`) 是一种监督学习算法。

## 从 Logistic Classification 到 SVM

`Logistic Classification`输出层中`sigmoid`函数将 $ \theta x $ 从(-∞, +∞)映射到(0,1)并依据阈值进行分类
\[
\theta^Tx >> 0 and h_\theta(x) \approx 1 \rightArrow y = 1
\theta^Tx << 0 and h_\theta(x) \approx 0 \rightArrow y = 0
\]

并通过以下`cost function`衡量代价（`without regularization`）

\[
\begin{align*}
J(\theta) & = \frac{1}{m}\sum_{i=1}^m -y^{(i)} \log(h_\theta(x^{(i)})) - (1 - y^{(i)})\log(1 - h_\theta(x^{(i)}))\\
& = \frac{1}{m}\sum_{i=1}^m -y^{(i)} \log\Big(\dfrac{1}{1 + e^{-\theta^Tx^{(i)}}}\Big) - (1 - y^{(i)})\log\Big(1 - \dfrac{1}{1 + e^{-\theta^Tx^{(i)}}}\Big)
\end{align*}
\]

`SVM`改变了 $ J\theta $ 中的代价计算函数

\[
    z          &= \theta x
    cost_0(z)  $= max(0, k(1+z)) \qquad\qquad k, slope of the line
    cost_1(z)  $= max(0, k(1-z)) \qquad\qquad k, slope of the line
\]

即

\[
   J(\theta) = \frac{1}{m}\sum_  
\]

|算法|激活函数|图像|
|:--:|:--:|:--:|
|logistic regression|$sigmod(z) = \frac{1}{1+e^{-z}}$|<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/sigmod函数图像.png" alt="sigmod函数图像" width="50%">|
|SVM|||