# 自适应实例标准化实现实时任意风格迁移

现有的风格迁移算法迭代优化过程缓慢，限制实际应用。基于前向反馈神经网络的快速逼近算法取得了更好的速度，但将网络同一组固定的风格绑定，不能实现任意风格的迁移。本文提出了迄今为止首个实现实时任意风格迁移的方法。核心方法是自适应实例标准化层（Adapative Instance Normalization layer）。AdaIN 层将原图特征的均值和方差对齐到风格特征的均值和方差。本文实现了单个前向反馈神经网络进行任意而不是预定义的一组风格的迁移，包括控制目标风格的比例，风格插值、色彩和空间控制，并与现存最快方法的速度相近。


## 1. Introdution
Gatys等人证明了DNN同时提取了图片的内容和风格两种信息，在某种程度上二者是可分的，因此保留内容而改变风格具有可能性。他们提出的方法能够将任意图片的风格迁移到其它图片，但因为需要一个迭代式的优化过程导致速度太慢。

有一些工作使用前向反馈神经网络的单次前向传播实现风格化。大多数前向反馈方法的主要局限在于每个网络限制于一个风格，近期有些工作拓宽到了一组风格，或者迁移任意风格但速度远远慢于单个风格。

受效果极好的实例规范化（层）的启发，我们解决了这个灵活性和速度的困境。实例规范化通过规范承载图像风格信息的特征统计数据实现风格规范化，根据这一理解，我们将IN拓展为AdaIN。AdaIN根据风格输入的均值和方差调整内容输入的方差和均值，学习出的解码器再将AdaIN的输出反向解码到图像空间生成风格化图像。比原始的DNN方法快了3个数量级。

## 2. Related Work

- 风格迁移：

风格迁移起源于非照片真实感渲染，与纹理合成及迁移密切相关。一些早期的方法如线性滤波器响应的直方图匹配和非参数化采样，依赖于低层次统计数据难以获取图像的语义结构。Gatys等人通过匹配DNN卷积层中的特征数据首次给出了令人印象深刻的风格迁移结果。Li and Wand在深层特征空间中引入了马尔科夫随机场来增强局部模式。Gatys 等人提出了色彩保留、空间位置和风格迁移的尺度的控制方法。Ruder等人通过施加时间约束提高了视频风格迁移的质量。
Gatys等人的框架基于一个迭代优化过程，通过损失网络最小化内容损失和风格损失。需要分钟级的时间才能收敛。

Ulyanov等提出了改善和提高生成图像的质量及多样性的方法。
Chen and M. Schmidt等提出了能迁移到任意风格的前馈网络，其中的风格交换层用匹配最接近的风格特征以块到块的方式替换内容特征。尽管如此，风格交换层造成了新的计算瓶颈：对于521x512的输入图像，风格交换产生了超过95%的计算开销。我们的方法在允许任意风格迁移的同时比此方法快1~2个数量级。

风格迁移的另一个核心问题是使用哪种风格损失函数。最初Gatys等人通过Gram矩阵捕获的特征激活图之间的二阶统计量匹配风格的统计量计算损失。其他有效的损失函数有马尔科夫随机场损失，对抗损失，直方图损失，CORAL loss，MMD loss 和通道均值和方差之间的距离。上述所有损失函数目的都是匹配风格图像和合成图像之间的某些特征统计信息。

- 深度生成图像建模

有一些用于图像生成的通用框架，包括VAE，自回归模型和GAN。其中GAN实现了最好的效果。许多GAN的改进方案如条件生成，多阶段处理和更好的训练目标被提出。GAN也被用于风格迁移和跨域图像生成。

## 3. Background

### 3.1 Batch Normalization

Ioffe and Szegedy提出的批量规范化影响深远，通过规范化特征统计量使FFN的训练变得容易。BN最初设计用于加速判别网络的训练，但也被发现在图像生成模型中有效。

给定一个batch $ x \in \mathbb{R}^{N\times C \times H \times W} $ 作为输入，BN 将每个通道的均值和标准差规范化。
\[
    {\rm BN}(x) = \gamma(\frac{x-\mu(x)}{\sigma(x)}) + \beta
\]
其中，$ \gamma, \beta \in \mathbb{R}^C $是从数据中学习到的仿射参数（`很可能是batch内数据得到，“are affine parameters learned from data”`）。$ \mu(x), \sigma(x) \in \mathbb{R}^C $是均值和标准差，每个特征通道的均值和标准差由 batch 的大小和空间维度计算得到：
\[
    \mu_c(x) = \frac{1}{NHW}\sum_{n=1}^N\sum_{h=1}^H\sum_{w=1}^Wx_{nchw}
    \\
    \sigma_c(x) = \sqrt{\frac{1}{NHW}\sum_{n=1}^N\sum_{h=1}^H\sum_{w=1}^W(x_{nchw}-\mu_c(x))^2 + \epsilon}  
\]
BN训练时使用mini-batch的统计数据，推理时使用全局统计数据，存在不一致。近来有 Batch Renormalization(BRN) 被提出在训练阶段逐渐过渡到全局统计数据。

> 有观点认为 style transfer 中很看重 $\mu, \sigma$，channel pruning 中比较看重 $\gamma, \beta$
...有观点认为 $\gamma, \beta$ 是 BN 的精髓，在归一化后进行还原，一定程度上保留原数据分布
（BRN在batch size比较小、batch的统计数据非独立同分布情况下效果明显）
BRN 认为在用每个batch的均值和方差来代替整体训练集的均值和方差时，可以再通过一个线性变换来逼近数据的真实分布
\[
    \frac{x_i - \mu}{\sigma} = \frac{x_i - \mu_{batch}}{\sigma_{batch}} \gamma + d
\]
而当
\[
    \gamma = \frac{\sigma_{batch}}{\sigma}, d = \frac{\mu_{batch} - \mu}{\sigma}
\]
时，就达到了理想的效果。

一些拓展BN效果的规范化策略也被应用于递归（循环）架构。

### 3.2 Instance Normalization
原始的前馈风格化方法中，每个卷积层后存在一个BN层。令人惊讶的是，Ulyanov发现将BN层替换为IN层带来了巨大的改善。
\[
    {\rm IN}(x) = \gamma(\frac{x-\mu(x)}{\sigma(x)}) + \beta
\]
其中，$\mu(x), \sigma(x)$为每个样本的每个通道在空间维度上独立计算。
\[
    \mu_{nc}(x) = \frac{1}{HW}\sum_{h=1}^H\sum_{w=1}^Wx_{nchw}
    \\
    \sigma_{nc}(x) = \sqrt{\frac{1}{HW}\sum_{h=1}^H\sum_{w=1}^W(x_{nchw}-\mu_{nc}(x))^2 + \epsilon}
\]
另一个区别是IN层训练和测试期间保持不变，而BN层测试中通常使用整个数据集的统计数据。

### 3.3 Conditional Instance Normalization
Duomoulin等人提出了条件样本标准化（CIN layer）为每个风格学习一组参数 $\gamma^s$ 和 $\beta^s$，而不是一直不变的一组仿射参数。
\[
    {\rm CIN}(x;s) = \gamma^s(\frac{x-\mu(x)}{\sigma(x)}) + \beta^s
\]
在Duomoulin的解决方案中，有32个风格和对应的 $\gamma^s$ 和 $\beta^s$ 可以选择。令人惊讶的是，使用相同的卷积参数仅仅IN层中的仿射参数不同，网络就可以生成不同风格的图片。
与不包括标准化层的网络相比，CIN层需要额外 $2FS$ 个参数，其中 $F$ 为CIN层输入的特征图数量， $S$ 为所支持的风格数目。这意味着额外参数量随着可迁移的风格数量线性增长，因此难以拓展到大量甚至任意风格。并且添加或更改任意风格都需要重新训练网络（来学习对应的 $\gamma^s$ 和 $\beta^s$）。

## 4. 样本规范化的解释
尽管（条件）样本规范化效果非常好，但它在风格迁移中为何有效仍然难以解释。Ulyanov等人认为IN的效果归功于它在图像内容对比度上具有不变性。然而IN作用于特征空间，应当比简单作用于像素空间的对比度规范化有更大的影响。事实可能更令人惊讶，IN层的仿射参数能完全控制输出图像的风格。

普遍认为DNN的卷积特征的统计数据能捕捉到图片的风格。Gatys等人使用二阶统计数据作为优化目标，Li等人近期证明了匹配许多其他的统计数据，例如通道层次的均值和方差对风格迁移也是有效的。受这些观察启发，我们认为样本规范化通过规范一些特征统计量（即均值和方差）形成了某种形式的风格规范化。虽然DNN作为图像的描述器工作，但我们认为生成器网络特征统计信息也能控制生成图像的风格。

我们测试了单风格迁移的纹理网络发现IN模型收敛得比BN快。如图1所示。
为了测试Ulyanov等人的解释，我们在亮度通道使用直方图均衡化将所有训练图片规范化到相同的对比度，再次测试，IN保持有效，说明Ulyanov等人的解释是不完善的。为了确认我们的假设，我们将所有训练图像转为非目标风格的同一风格，IN的提升效果小了许多。BN和IN间存在的gap可以解释为我们对训练图像所使用的风格迁移并不完美。并且，BN模型在风格规范化后的训练图像上和IN在原始训练图像上收敛的一样快。我们的实验说明了IN确实相当于执行某种风格规范化。

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/BN  vs IN.png" alt="BN  vs IN" width="100%">

figure 1. BN layer v.s. IN layer

因为 BN 以 batch 而不是样本为单位进行特征统计量的规范化，因此可以直观地理解为样本以 batch 为单位向某个风格规范化，然而每个样本有各自的风格，这是我们将相同风格迁移到所有图像时所不希望的。即使卷积层可能学会在 batch 内进行风格差异补偿，但这仍然为训练带来挑战。
另一方面，IN可以将每个样本的风格规范化为目标风格，网络能关注于内容的处理并丢弃原风格信息，从而有利于训练。CIN 的成功也变得明了：不同的仿射参数将特征统计量规范化为不同的值，输出图像也就具有不同风格。

## 5. Adaptive Instance Normalization
如果说IN将输入规范化到仿射参数所确定的某个风格，那么有没有可能将IN适应到任意给定的风格呢？我们简单拓展了IN，提出了Adaptive Instance Normalization(AdaIN)。AdaIN 接受一个内容输入 $x$ 和一个风格输入 $y$，直接将内容输入 $x$ 的均值和方差按通道对齐到风格风格输入 $y$。与 BN/IN/CIN 不同，AdaIN 的仿射参数 $\gamma$ 和 $\beta$ 直接由风格输入计算得来，而非网络学习得到。
\[
    {\rm AdaIN}(x,y) = \sigma(y)(\frac{x-\mu(x)}{\sigma(x)}) + \mu(y)
\]

> 内容输入归一化为正态分布后进行放缩、偏移，对齐到按照风格输入的分布

其中，$\gamma = \sigma(y), \beta = \mu(y)$。与 IN 类似，这些统计数据是跨空间位置计算得到的。

直观地说，想象一个检测某个风格的特征通道，一张风格图像中的这种笔划将对该特征产生高水平的激活，从而AdaIN的输出也会在这个特征上表现出相同的高水平激活，同时保留内容图像的空间结构。这种笔触特征能被前馈解码器反向转换到图像空间（像CNN那样）。特征通道的方差能编码更精细的风格信息，也被反映在 AdaIN 的输出和在最终输出的图像中。

简而言之，AdaIN 通过迁移特征统计数据（具体说是通道层次的均值和方差）实现特征空间中的风格迁移。我们的 AdaIN 和 Chen and M. Schmidt 的 style swap 风格交换层扮演着同样的角色，而 style swap layer 时间复杂度、空间复杂度都很高，AdaIN 和 IN 一样简单，几乎没有增加计算开销。

## 6. Experimental Setup

### 6.1 overview

由 Torch7 实现。https://github.com/xunhuang1995/AdaIN-style

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/AdaIN网络架构.png" alt="AdaIN网络架构" width="80%">

>网络架构：
 一个固定的预训练的VGG-19的前几层网络作为输入的编码器，后面的 AdaIN layer 在特征空间中进行风格迁移，训练的解码器将  AdaIN layer 的输出反转到图像空间。损失由相同的编码器分别计算内容损失 $\mathcal{L}_c$ 和风格损失 $\mathcal{L}_s$。

AdaIN layer 以编码器 $f$ 输出的内容特征图和风格特征图作为输入，将内容特征图的均值和方差对齐到风格特征图，得到目标特征图 $t$ 作为 AdaIN layer 的输出：
\[
    t = AdaIN(f(c),f(s))
\]
随机初始化然后进行训练的解码器 $g$ 将特征图 $t$ 映射回图像空间，生成风格化的图像 $T(c,s)$：
\[
    T(c,s) = g(t)
\]
解码器几乎是编码器的镜像，前者将后者的池化层替换为最近上采样层来缓解**棋盘效应**。我们在编码器和解码器中使用**反射填充**避免边界伪影。另一个重要的架构选择是解码器是否该使用 instance/batch/no 规范化层。Sec. 4 中说明 IN 将样本规范化为某个风格，BN 将整个 batch 的样本规范化为这个 batch 的平均风格。都不是风格迁移所想要的，因此解码器中不使用规范化层。Sec. 7.1 证明了解码器中的规范化层损害了迁移效果。

### 6.2 训练过程

内容图像由MS-COCO提供，风格图像在 WikiArt 上收集。每个 batch 包含8对内容和风格图像。使用了Chen and M. Schmidt.的一些设置。
在训练过程中，我们首先将两幅图像的最小尺寸调整为512，同时保留纵横比，然后随机裁剪大小为256×256的区域。因为模型是全卷积网络，所以能以任何尺寸的图像作为输入。

和其他工作一样，我们使用一个预训练的 VGG-19 计算 loss：
\[
    \mathcal{L} = \mathcal{L}_c + \lambda\mathcal{L}_s
\]
内容损失是目标图像的特征向量（AdaIN 的输出）和输出图像的特征向量之间的欧氏距离（Euclidean distance）。使用目标图像的特征向量**而不是普遍使用的内容图像的特征向量**稍稍加快了模型的收敛，同时也和我们反转 AdaIN 的输出 $t$ 到图像空间这一目标契合。
\[
    \mathcal{L}_c = \Vert f(g(t)) - t \Vert_2
\]
由于风格输入只向 AdaIN layer 层传递了均值和方差，因此风格损失仅计算这两项。虽然 Gram 矩阵损失可以产生相似的结果，但我们仍然使用样本归一化的统计数据，因为它们概念上更清晰。Li等人也讨论了风格损失的计算。
\[
    \mathcal{L}_s = \sum_{i=1}^L\Vert \mu(\phi_i(g(t))) - \mu(\phi_i(s)) \Vert_2 + \sum_{i=1}^L\Vert \sigma(\phi_i(g(t))) - \sigma(\phi_i(s)) \Vert_2
\]
其中，每个 $\phi_i$ 表示 VGG-19 中用来计算风格损失的单层网络，我们的实验中使用了relu1_1, relu2_1, relu3_1, relu4_1 层和相同的权重。

## 7. Results

### 7.1 与其他方法的对比
其他方法：
1) 灵活但基于缓慢的优化方法
2) 快速前馈网络但限制于单一风格
3) 灵活的基于块的方法

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/风格迁移效果对比图.png" alt="风格迁移效果对比图" width="100%">

|研究者|研究|
|:---:|:---:|
|Ulyanov等|改善图像质量和多样性、以 IN 代替 BN|
|Chen and M. Schmidt等|style swap 块匹配|
|Duomoulin等|CIN layer|
|Ours|AdaIN|


- 定性分析

认为我们提出的方法效果有好有坏，但模型训练期间未见过测试风格，其他方法可能仅支持有限的风格因此测试风格就是训练风格。
并且指出基于块匹配的方法(Chen and M. Schmidt)存在问题：如果大多数内容块只与一小部分风格块匹配，可能不具有目标风格的代表性，导致迁移失败。而他们的方法则从全局的特征统计数据进行匹配，更具普遍性。

- 定量分析（对比损失）

我们提出的方法是否为了速度和灵活性牺牲了迁移质量？如果是，牺牲了多少？对比 loss（修改了一些方法的损失函数进行对比，因为我们的方法基于 IN 计算损失）

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/风格迁移损失定量比较.png" alt="风格迁移损失定量比较" width="60%">

风格损失略高于单风格迁移方法，大约为DNN迭代优化方法迭代50~100次的效果，但仍远低于原始图像与目标风格间的损失。（注意该方法训练期间未见过测试风格）


<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/风格迁移速度比较.png" width="60%">

> 括号中的速度为包含风格图像编码的时间（固定风格模型不需要重新编码，而任意风格模型通常需编码一次）。单位为秒。

同现有支持任意风格迁移的方法相比有明显速度优势，同固定风格模型相比有明显速度优势。

### 7.2 额外实验

验证模型的架构选择。
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/AdaIN架构选择实验.png" alt="AdaIN架构选择实验" width="80%">

> a 风格，b 内容，c 当前架构Encoder-AdaIN-Decoder，
d Encoder-Concat-Decoder（内容叠加风格，baseline），
e Encoder-AdaIN-Decoder_with_BN，
f Encoder-AdaIN-Decoder_with_IN

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/风格迁移训练曲线和损失.png" alt="风格迁移训练曲线和损失" width="80%">

### 7.3 Runtime controls

运行时控制进一步展现了模型的灵活性，这些控制仅需在运行时控制，无需重新训练网络。

- 内容-风格 平衡

1) 训练期间调节 content-style loss weight $\lambda$
2) 测试期间对输入 Decoder 的特征图进行插值（等价于在 AdaIN 对仿射参数插值）
\[
    T(c,s,\alpha) = g((1-\alpha)f(c) + \alpha AdaIN(f(c), f(s)))
\]
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/风格迁移内容与风格平衡.png" alt="风格迁移内容与风格平衡" width="100%">

- 风格插值

将一组大小为 K 的风格 $s_1,s_2,\dots,s_k$ 分别以 $w_1,w_2,\dots,w_k$ 为权重按插值的形式迁移，同样在特征图中进行插值实现。

\[
    T(c,s_{1,2,\dots,k},w_{1,2,\dots,k}) = g(\sum_{k=1}^K w_k AdaIN(f(c),f(s_k)))
\]
且 \( \sum_{k=1}^K w_k = 1 \)

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/风格迁移多个风格插值示例.png" alt="风格迁移多个风格插值示例" width="80%">

- 位置和色彩控制

Gatys等人最近介绍了用户对颜色信息和风格转移的空间位置的控制。为了保留内容图像的色彩分布，先将风格图像的色彩分布匹配到内容图像（与Gatys等人一样），然后将色彩对齐的风格图作为风格输入进行风格迁移。

使用不同风格输入的统计数据，分别对内容特征图中的不同区域执行 AdaIN 实现位置控制。

> 可以对全图执行AdaIN，但只对目标位置生效

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/风格迁移位置和色彩控制效果示例.png" alt="风格迁移位置和色彩控制效果示例" width="80%">