<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=5 orderedList=false} -->

<!-- code_chunk_output -->

- [Parameters in Training Deep Learning Models](#parameters-in-training-deep-learning-models)
  - [Learning Rate](#learning-rate)
    - [Root Mean Square (RMS)](#root-mean-square-rms)
    - [Root Mean Square (RMS)](#root-mean-square-rms-1)
    - [Adam](#adam)

<!-- /code_chunk_output -->

# Parameters in Training Deep Learning Models

## Learning Rate

使用梯度下降优化损失的过程中，需要调整学习率来适应梯度的变化。
例如，lr过大导致loss震荡，无法继续下降。
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/lr不合适导致loss震荡.png" alt="lr不合适导致loss震荡" width="30%">
 $ lr $ 选取较大则算法迭代次数较少，$ lr $ 选取较小则算法迭代次数较多，此外
- $ lr $ 设置过大可能导致最小值被跨过，$ loss $ 不减反升，甚至导致迭代过程发散，无法收敛至最小值
- $ lr $ 设置过小会使算法迭代次数过多，导致性能问题

因此， $ lr $ 需要设置为一个合理的值，数学表明，若 $ lr $ 足够小， 在每次迭代中损失函数一定是递减的。即使 $ lr $ 是一个固定的值，每次迭代的移动步长也会随着斜率减小而减小，从而到达极小值点。

因此需要一些根据 $ gradient $ 动态调整 $ lr $ 的方法。

### Root Mean Square (RMS)
\[
    \theta_i^{t+1} = \theta_i^t - \it
    \sigma_i^t = \sqrt{ \frac{1}{t+1} \sum_{i=0}^t {(g_i^t)}^2 }
\]

### Root Mean Square (RMS)

### Adam