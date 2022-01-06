<!-- @import "[TOC]" {cmd="toc" depthFrom=3 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Tittle](#tittle)
- [Date & Source](#date-source)
- [Abstract](#abstract)
- [Introduction](#introduction)
- [Related Work](#related-work)
  - [Object Detection(目标检测)](#object-detection目标检测)
  - [Image Adaptation(图像自适应)](#image-adaptation图像自适应)
  - [Object Detection in Adverse Conditions(恶劣条件下目标检测)](#object-detection-in-adverse-conditions恶劣条件下目标检测)
- [Proposed Method](#proposed-method)
  - [DIP Module(可微图像处理模块)](#dip-module可微图像处理模块)

<!-- /code_chunk_output -->

### Tittle

Image-Adaptive YOLO for Object Detection in Adverse Weather Conditions

恶劣天气下的目标检测模型图像自适应 YOLO

### Date & Source

arXiv:2112.08088 v1
AAAI 2022 ZJU

### Abstract

&emsp;&emsp;即使在传统数据集上基于深度学习的目标检测方法已经取得了可观的效果，在恶劣天气条件下拍摄的低质量图片中定位目标仍是具有挑战性的。已存在的方法要么难以平衡图像增强(image enhancement)和目标检测(object detection)任务，要么常常忽视对检测有益的潜在信息。为缓解这一问题，我们提出了一个新的图像自适应 YOLO (Image-Adaptive YOLO, IA-YOLO)框架，其中每张图像都可以自适应地增强以取得更好的检测效果。特别地，考虑到 YOLO 检测器面临的恶劣天气条件， 我们提出了一个可微图像处理(differentiable image processing, DIP)模块，该模块的参数使用一个称为 CNN-PP 的小规模卷积神经网络预测得到。我们以一种端到端的方式共同训练 CNN-PP 和 YOLOv3，这以一种弱监督的方式保证了 CNN-PP 能学习到一个合适的 DIP 来为目标检测增强图片。我们提出的 IA-YOLO 方法可以自适应地处理正常和恶劣天气条件下的图片。实验结果是非常令人鼓舞的，在有雾和低光照场景中证明了 IA-YOLO 有效性。源代码开放在 https://github.com/wenyyu/ImageAdaptive-YOLO。


### Introduction

&emsp;&emsp;在目标检测中基于 CNN 的方法已经变得非常流行 [<sup>[1]</sup>](#refer_1) [<sup>[2]</sup>](#refer_2)。他们不仅在基准数据集上实现了令人满意的效果 [<sup>[3]</sup>](#refer_3) [<sup>[4]</sup>](#refer_4) [<sup>[5]</sup>](#refer_5)，并且已经部署到实际应用中如自动驾驶 [<sup>[6]</sup>](#refer_6)。由于输入图像的领域偏移(domain shift) [<sup>[7]</sup>](#refer_7) 高质量图片训练出的一般目标检测模型通常在恶劣天气条件下（如雾天和低光照）难以获得令人满意的结果。Narasimhan 和 Nayar [<sup>[8]</sup>](#refer_8) 还有 You [<sup>[9]</sup>](#refer_9) 提出恶劣天气下获取的图像可以被分解为清晰的图片和相应的特定天气信息，并且恶劣天气下图像质量退化主要由于特定天气信息和目标的相互作用造成，这导致了不理想的检测效果。[图1](#fig_1)展示了一个雾霭条件下的目标检测示例。可以看出如果图片根据天气情况被适当增强，则可以恢复原始模糊目标和误判的目标的更多潜在信息。

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/20220104224520.png" alt="20220104224520" style="clear:both;display:block;margin:auto;" width="80%" id="fig_1">

> Figure 1: In the real-world foggy condition, our method can adaptively output clearer images with sharper edges around objects’ boundary, and consequently produce higher confidence detection results with fewer missing instances.
图1，在真正的雾天中，我们的方法可以自适应地输出更清晰，边缘更鲜明的目标边界图像，从而在更少缺失目标实体的情况下产生更高置信度的检测结果。

&emsp;&emsp;为了解决这个具有挑战性的问题，Huang, Le 和 Jaw [<sup>[10]</sup>](#refer_10) 使用两个子网络共同学习可见性增强和目标检测，通过共享特征提取层来减少图像退化的影响。然而，在训练过程中很难调整参数来平衡检测和恢复之间的权重。另一种方案是使用现有方法如去雾 [<sup>[11]</sup>](#refer_11) [<sup>[12]</sup>](#refer_12) 和图像增强 [<sup>[13]</sup>](#refer_13) 预处理图像以减轻特定天气信息的影响。然而这些方法不得不包含复杂的、需要用像素级监督学习单独训练的图像恢复网络，需要手动标注要恢复的图像。这也可以视为无监督的领域适应(domain adaptation)任务 [<sup>[14]</sup>](#refer_14) [<sup>[15]</sup>](#refer_15)。相对于用清晰图像（源图像）训练分类器，假定恶劣天气下捕获的图像（目标图像）存在分布迁移(distribution shift)。这些方法主要采用域适应原理并聚焦于两种分布的特征对齐，基于天气的图像恢复过程中可能获得的潜在信息往往被忽略了。

&emsp;&emsp;为了克服以上局限性，我们提出了一个巧妙的自适应目标检测方法，称为 IA-YOLO。确切地说，我们提出一个全可微的图像处理模块(DIP)，它的超参数由一个基于 CNN 的小规模参数预测器(CNN parameter predictor, CNN-PP)自适应地学习得到。CNN-PP 根据输入图片的亮度、色彩、色调和特定天气信息自适应地预测 DIP 的超参数。DIP 处理后的图片可以抑制特定天气信息的干扰并恢复潜在的信息。我们提出了一个共同优化计划以端到端的方式来学习 DIP, CNN-PP 和 YOLOv3 骨干检测网络 [<sup>[16]</sup>](#refer_1) 。为了增强所检测的图片，CNN-PP 通过 bounding box 标注弱监督地学习一个适当的 DIP。此外，我们充分利用了正常和恶劣天气的图像来训练提出的网络。通过利用 CNN-PP 网络，我们提出的 IA-YOLO 方法能够自适应地处理不同程度的天气状况影响的图片。[图1](#fig_1)展示了我们提出的方法检测结果的一个示例。

&emsp;&emsp;该工作的亮点在于：1) 提出了一个图像自适应的检测框架，在普通和恶劣天气条件下都实现了令人满意的效果。2) 提出了一个白盒可微图像处理模块，其超参数是由弱监督参数预测网络所预测的。3) 与以前的方法相比，在合成测试集(synthetic testbeds)（VOC_Foggy 和 VOC_Dark）和真实数据集(real-world datasets)（RTTS 和 ExDark）上得到了振奋人心的实验结果。

### Related Work

#### Object Detection(目标检测)

&emsp;&emsp;目标检测作为计算机视觉(Computer Vision, CV)的一项基本任务受到了密切关注。目标检测方法可以被粗略地分为两类 [<sup>[16]</sup>](#refer_16)。一类是基于区域建议(region proposal)的方法 [<sup>[17]</sup>](#refer_17) [<sup>[18]</sup>](#refer_18) [<sup>[2]</sup>](#refer_2)，首先从图片中产生兴趣区域(regions of interest, RoIs)再通过训练神经网络对它们分类。另一类是基于回归的单段式(onee-stage)方法如 YOLO 系列 [<sup>[1]</sup>](#refer_1) [<sup>[19]</sup>](#refer_19) [<sup>[20]</sup>](#refer_20) [<sup>[21]</sup>](#refer_21) 和 SSD [<sup>[22]</sup>](#refer_22)，它们的物体标签和 bounding box 坐标是同一个 CNN 预测的。本文使用经典的 one-stage 检测器 YOLOv3 [<sup>[1]</sup>](#refer_1) 作为基线(baseline)检测器，在恶劣条件下提高其性能。

#### Image Adaptation(图像自适应)

&emsp;&emsp;图像自适应(image adaptation)在图像增强中广泛使用。为了恰当地增强图片，一些传统方法 [<sup>[23]</sup>](#refer_23) [<sup>[24]</sup>](#refer_24) [<sup>[25]</sup>](#refer_25) 根据相应图像特征自适应地计算图像转换参数。例如，Wang [<sup>[24]</sup>](#refer_24) 提出了一个基于输入图片的光源分布特征自适应调整亮度的函数。
&emsp;&emsp;为了实现自适应的图像增强，Hu [<sup>[25]</sup>](#refer_25), Yu [<sup>[26]</sup>](#refer_26) 和 Zeng [<sup>[27]</sup>](#refer_27) 使用小规模的 CNN 灵活地学习图像转换超参数。Hu [<sup>[25]</sup>](#refer_25) 提出了包含一套可微滤波器的后处理(post-processing)框架，该框架使用深度强化学习(reinforcement learning, RL)根据当前修饰的图片的质量产生图像操作和滤波器参数。Zeng [<sup>[27]</sup>](#refer_27) 利用小规模 CNN 根据全局上下文信息如亮度、色彩和色调学习图像自适应 3D LUT。

#### Object Detection in Adverse Conditions(恶劣条件下目标检测)

&emsp;&emsp;与一般目标检测相比，恶劣天气下目标检测的研究较少。一个简单直接(straightforward)的方法是使用经典去雾或图像增强方法 [<sup>[]</sup>](#refer_) [<sup>[]</sup>](#refer_) [<sup>[]</sup>](#refer_) [<sup>[]</sup>](#refer_) [<sup>[]</sup>](#refer_) [<sup>[]</sup>](#refer_)，这些方法原本被设计用于除雾或图像质量增强。然而，提升图像质量可能并非绝对有益于检测效果。一些基于先验知识的方法 [<sup>[]</sup>](#refer_) [<sup>[]</sup>](#refer_) 共同使用图像增强和检测来减弱(attenuate)特定恶劣天气的干扰。Sindagi [<sup>[]</sup>](#refer_) 提出一种无监督的基于先验知识的域对抗性目标检测框架，用于雨雾条件。一些方法 [<sup>[]</sup>](#refer_) [<sup>[]</sup>](#refer_) [<sup>[]</sup>](#refer_) 利用域适应解决这个问题。Hnewa 和 Radha [<sup>[]</sup>](#refer_) 假设正常天气和恶劣天气下捕获的图像之间存在域偏移，他们设计了多尺度(multi-scale)域适应 YOLO，在特征提取阶段支持在不同层的域自适应。

### Proposed Method

&emsp;&emsp;由于特定天气信息的干扰，恶劣天气条件下拍摄的图像可见度较差，导致目标检测的困难。为了应对这一挑战，我们提出了通过去除特定天气信息并揭示更多潜在信息的图像自适应检测框架。如[图2](#fig_2)所示，整个流水线由一个基于 CNN 的参数预测器（CNN-PP），一个可微图像处理模块（DIP）和一个检测网络构成。我们首先调整输入图片的大小至 256 × 256，然后输入至 CNN-PP 中预测 DIP 的参数。接下来，将 DIP 过滤后的图像作为 YOLOv3 检测器的输入。我们提出一种具有检测 loss 的端到端混合数据训练方案，以弱监督的方式使 CNN-PP 学习到合适的 DIP 来增强目标检测的图像。
<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/IA_YOLO_fig_2.png" alt="IA_YOLO_fig_2" style="clear:both;display:block;margin:auto;" width="80%" id="fig_2">
> Figure 2: The end-to-end training pipeline of the proposed IA-YOLO framework. Our method learns a YOLO with a small CNN-based parameter predictor (CNN-PP), which employs the downsampled input image to predict the hyperparamters of filters in the DIP module. The high-resolution input images are processed by DIP’s filters to aid YOLOv3 achieve high detection performance. The Defog filter is only used in foggy conditions.
IA-YOLO 中的端到端训练流水线。我们的方法使用一个基于 CNN 小规模参数预测器学习一个 YOLO 模型，该预测器采用下采样的输入图片来预测 DIP 模块的超参数。为使 YOLOv3 实现较好的性能，高分辨率的输入图片通过 DIP 的滤波器进行处理。除雾滤波器仅在有雾情况下使用。

#### DIP Module(可微图像处理模块)

&emsp;&emsp;如同 [<sup>[25]</sup>](#refer_25) 所述，图像滤波器的设计应当遵守可微性(differentiability)和分辨率独立(resolution-independent)的原则。为了进行 CNN-PP 基于梯度的优化，滤波器应当是可微的，以允许通过反向传播来训练网络。因为 CNN 处理高分辨率图像（如 4000 × 3000）会消耗大量的计算资源，本文我们从下采样 256 × 256 大小的低分辨率学习滤波器参数，并使用在原始分辨率图像上。因此，这些滤波器应当是独立于图像分辨率的。
&emsp;&emsp;我们提出的 DIP 模块由六个可调整超参数的可微滤波器组成，包括 *Defog*、*White Balance (WB)*、*Gamma*、*Contrast*、*Tone* 和 *Sharpen*。如同 [<sup>[25]</sup>](#refer_25) 所述，标准色彩和色调算子例如 *WB*、*Gamma*、*Contrast* 和 *Tone* 可以由像素级滤波器(pixel-wise filters)表达。因此我们设计的滤波器可以分为 *Defog*，*Pixel-wise filters* 和 *Sharpen* 三类。在这些分类器中，*Defog* 分类器是为雾霭场景特别设计的。细节如下。

**Pixel-wise Filters.**&emsp;&emsp;像素级滤波器将输入像素值 $ P_i = (r_i, g_i, b_i) $ 映射为输出像素值 $ P_o = (r_o, g_o, b_o) $，其中 $ (r, g, b) $ 分别表示红绿蓝三个通道的值。四个像素级滤波器的映射函数列在[表1](#tab_1)中，第二列中列出了我们的方法中需要优化的参数。*WB* 和 *Gamma* 是简单的乘法和乘方变换。显然，它们的映射函数关于输入图片和参数来说都是可微的。

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/IA_YOLO_tab_1.png" alt="IA_YOLO_tab_1" style="clear:both;display:block;margin:auto;" width="60%" id="tab_1">

&emsp;&emsp;可微的对比度滤波器设计中含有一个输入参数来设置原始图片和完全增强图片之间的线性插值。如[表1](#tab_1)所示，映射函数中 $ En(P_i) $ 的定义如下：

\[  
  \begin{equation}
  Lum(P_i) = 0.27r_i + 067.g_i + 0.06b_i
  \end{equation}
\]
\[  
  \begin{equation}
  EnLum(P_i) = \frac{1}{2}(1-\cos{(\pi\times(Lum(P_i)))})
  \end{equation}
\]
\[  
  \begin{equation}
  En(P_i) = P_i \times \frac{EnLum(P_i)}{Lum(P_i)}
  \end{equation}
\]

如同 [<sup>[25]</sup>](#refer_25) 所述，我们将色调滤波器设计为单调(monotonic)分段线性(piecewise-linear)函数。我们用 $ L $ 个参数学习色调滤波器，用 $ \{t_0, t_1, \dots t_{L-1}\} $ 表示。色调曲线的点表示为 $ (k/L, T_k/T_L) $ ，其中 $ T_k = \sum_{i=0}^{k-1}t_l $ . 此外，映射函数由可微的参数表示使得函数关于输入图像和参数 $ \{t_0, t_1, \dots t_{L-1}\} $ 都是可微的：
\[  
  \begin{equation}
  P_o = \frac{1}{T_L} \sum_{j=0}^{L-1} clip(L \cdot P_i - j, 0, 1) t_k
  \end{equation}
\]

**Sharpen Filter.**&emsp;&emsp;图像锐化能突出图像的细节。与非锐化蒙版技术 [<sup>[]</sup>](#refer_) 一样，瑞华过程可以描述如下：

\[  
  \begin{equation}
  F(x, \lambda) = I(x) + \lambda(I(x) - Gau(I(x)))
  \end{equation}
\]

其中 $ I(x) $ 是输入图像，$ Gau(I(x)) $ 表示高斯滤波器(Gaussian filter)，$ \lambda $ 是一个正比例因子(positive scaling factor)。锐化操作关于 $x$ 和 $\lambda$ 都是可微的。请注意，可以通过优化 $\lambda$ 来调整锐化度以获得更好的目标检测性能。

**Defog Filter.**&emsp;&emsp;受暗通道先验方法(dark channel prior method) [<sup>[]</sup>](#refer_) 的启发，我们设计了含有可学习参数的除雾滤波器。基于大气散射模型(atmospheric scattering model) [<sup>[]</sup>](#refer_) [<sup>[]</sup>](#refer_) ，模糊图像可以被公式化表示为：

<div id="eq_6"><div>

\[  
  \begin{equation}
  I(x) = J(x)t(x) + A(1-t(x))
  \end{equation}
\]

其中，$I(x)$ 表示有雾的图像，$J(x)$ 表示场景辐射率(scene radiance)（即清晰图像）。$A$ 是全局大气光(global atomspheric light)，$t(x)$是介质传输图(medium transmission map)，其定义为：

<div id="eq_7"><div>

\[  
  \begin{equation}
  t(x) = e^{-\beta}d(x)
  \end{equation}
\]

其中，$\beta$ 表示大气散射系数(scattering coefficient)，$d(x)$ 表示景深(scene depth)。
&emsp;&emsp;为了恢复清晰图像 $J(x)$，关键是获得全局大气光 $A$ 和介质传输图 $t(x)$。为此，我们先计算暗通道图(dark channel map) 并收集前 1000 亮度最高的像素点，然后通过它们的平均值估计模糊图像 $I(x)$ 的 $A$。
&emsp;&emsp;根据[公式(6)](#eq_6)可以推导出 $t(x)$ 的近似解(approximate solution) [<sup>[]</sup>](#refer_) 如下：

\[  
  \begin{equation}
  t(x) = 1 - \min_{C} \Big( \min_{y \in \Omega(x)} \frac{I^C(y)}{A^C} \Big)
  \end{equation}
\]

我们进一步引入参数 $\omega$ 来控制除雾强度，如下所示：

\[  
  \begin{equation}
  t(x) = 1 - \min_{C} \omega \Big( \min_{y \in \Omega(x)} \frac{I^C(y)}{A^C} \Big)
  \end{equation}
\]

因为以上操作是可微的，我们可以用反向传播优化 $\omega$ 使除雾滤波器更有利于雾霭图片的检测。


#### CNN-PP Module(CNN-PP 模块)

&emsp;&emsp;在摄像头图像信号处理(ISP)流水线中，通常使用一些可调节的滤波器进行图像增强，经验丰富的工程师凭借视觉观察手动调整它们的超参数。[<sup>[]</sup>](#refer_) 。一般来说，这样为较大范围场景寻找恰当参数的调整过程笨拙又昂贵。为了解决这一限制，我们提出使用一个小规模 CNN 作为参数预测器来高效地估计超参数。
&emsp;&emsp;以有雾图片为例，CNN-PP 的目的是通过理解图片全局内容如亮度、色彩色调以及雾的程度预测 DIP 的参数。因此下采样的图片足够估计这些信息，且极大地节约了计算开销。对于任意分辨率的图像，使用双线性插值进行 256 × 256 的下采样。如[图2](#fig_2)所示，CNN-PP 网络由五个卷积块和两个全连接层组成，每个卷积块是步长为 2 的 3×3 的卷积层和 leaky Relu 激活层。最后的全连接层输出 DIP 的超参数。五个卷积层的输出通道数分别为 16，32，32，32，32. 当预测 15 个 DIP 参数时 CNN-PP 模型仅含有 165K 个参数。

#### Detection Network Module(检测网络模块)

&emsp;&emsp;本文选择单段式检测器 YOLOv3 作为检测网络，YOLOv3 在图像编辑，安全监控，人群检测和自动驾驶中存在广泛的实际应用 [<sup>[]</sup>](#refer_)。相比于先前的版本 YOLOv3 基于 Resnet [<sup>[]</sup>](#refer_) 的思想设计了连续的 3×3 和 1×1 的卷积层组成的 Darknet-53。通过多尺度特征图进行预测实现多尺度训练，以进一步提高尤其是小目标的检测准确率。我们使用了原始 YOLOv3 [<sup>[1]</sup>](#refer_1) 相同的网络架构和损失函数。

#### Hybrid Data Training(混合数据训练)

&emsp;&emsp;为了在普通和恶劣天气条件下都实现理想的检测效果，我们为 IA-YOLO 采用了混合数据训练方案。[算法1](#alg_1)归纳了训练过程。在输入到网络中训练前，每张图片有 2/3 的概率被随机添加一些雾或者被转换为低光照图像。使用正常和合成的低质量训练数据，使用 YOLOv3 的检测损失对整个流水线进行端到端的训练，保证 IA-YOLO 中的所有模块可以相互适应。因此 CNN-PP 模型受到检测损失的弱监督而无需人工标注真实结果。混合数据训练方式确保 IA-YOLO 能根据图像内容自适应地进行处理，从而实现较好检测效果。

```latex {cmd=true}
%\documentclass{standalone}
\documentclass{article}
\usepackage{algorithm}
\usepackage{algorithmicx}
\usepackage{algpseudocode}
\begin{document}
\begin{algorithm}
	\caption{HHS \cite{Branch1998}}
	\label{hhsa}
	\begin{algorithmic}[1]  %1表示每隔一行编号	
		\Require The original signal $x$.
		\Ensure  The energy-time-frequency distribution of $x$. 
		\Function{EMD}{$x, seg\_len$}
		\State $ N \gets length(x) / seg\_len$;
		\For {$i=1 \to i=N$}
		\State $seg(i) \gets x(1+(i-1)*seg\_len : i*seg\_len)$;
		\EndFor
		\EndFunction
	\end{algorithmic}
\end{algorithm}
\end{document}
```

### Experiments

&emsp;&emsp;我们评估了该方法在雾霭和低光照场景下的有效性。滤波器组合是 [*Defog*、*White Balance (WB)*、*Gamma*、*Contrast*、*Tone*、*Sharpen*] 且除雾滤波器仅用于有雾条件。

#### Implementation Details(实现细节)

&emsp;&emsp;我们采用了 [<sup>[1]</sup>](#refer_1) 中的训练协议。所有实验的骨干网络是 Darknet-53。训练过程中随机将图片 resize 至 $32N$ × $32N$，其中 $ N\in[9,19] $。此外，使用数据增强方法如翻转、裁剪和变换扩展训练集，使用 Adam 优化器 [<sup>[]</sup>](#refer_) 训练 80 轮次。初始学习率为 10^-4^，batch size 为 6。IA-YOLO 在三个不同的尺度上预测 bounding box，每个尺度上三个 anchors。我们在 Tesla V100 GPU 上使用 Tensorflow 框架。

#### Experiments on Foggy Images(有雾图像实验)

**Datasets.**&emsp;&emsp;用于恶劣天气条件下目标检测的公开数据集较少，并且对于训练基于 CNN 的稳定的检测器来说通常数据量较小。为了便于公平比较，我们在经典 VOC 数据集 [<sup>[]</sup>](#refer_) 的基础上根据大气散射模型 [<sup>[8]</sup>](#refer_8) 建立了 VOC_Foggy 数据集。此外，RTTS [<sup>[]</sup>](#refer_) 是一个相对综合的真实雾天数据集，包含 4322 个自然模糊图像，含有五种标注类别：人，自行车，汽车，公交车及摩托车。为了构建训练集，我们挑选了包含这五种类别的图片添加雾霭。
&emsp;&emsp;对于 VOC2007_trainval 和 VOC2012_trainval，我们过滤得到含有上述五个类别的物体的图片构成 VOC_norm_trainval. VOC_norm_test 是以类似的方式从 VOC2007_test 中选出的。我们还在 RTTS 上评估了我们的方法。[表2](#tab_2)汇总了数据集的统计数据。

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/IA_YOLO_tab_2.png" alt="IA_YOLO_tab_2" style="clear:both;display:block;margin:auto;" width="80%" id="tab_2">

&emsp;&emsp;为了避免训练过程中产生有雾图像的计算开销，我们离线构建数据集 VOC_Foggy. 根据[公式6](#eq_6)，[7](#eq_7)，有雾图像 $I(x)$ 是这样得到的：

\[
  \begin{equation}
  I(x) = J(x)e^{-\beta} d(x) + A(1-e^{-\beta} d(x))
  \end{equation}
\]

$d(x)$ 定义如下：

\[
  \begin{equation}
  d(x) = -0.04 * \rho + \sqrt{\max(row, col)}
  \end{equation}
\]







### References
<div id="refer_1"></div>

- [1] [Redmon, J.; and Farhadi, A. 2018. Yolov3: An incremental improvement. arXiv:1804.02767.]()

<div id="refer_2"></div>

- [2] [Ren, S.; He, K.; Girshick, R.; and Sun, J. 2015. Faster r-cnn: Towards real-time object detection with region proposal networks. Advances in Neural Information Processing Systems, 28: 91–99.]()

<div id="refer_3"></div>

- [3] [Deng, J.; Dong, W.; Socher, R.; Li, L.-J.; Li, K.; and Fei-Fei, L. 2009. Imagenet: A large-scale hierarchical image database. In Proceedings of IEEE/CVF Conference Computer Vision Pattern Recognition (CVPR), 248–255. IEEE.]()

<div id="refer_4"></div>

- [4] [Everingham, M.; Van Gool, L.; Williams, C. K.; Winn, J.; and Zisserman, A. 2010. The pascal visual object classes (voc) challenge. International Journal of Computer Vision, 88(2): 303–338.]()

<div id="refer_5"></div>

- [5] [Lin, T.-Y.; Maire, M.; Belongie, S.; Hays, J.; Perona, P.; Ramanan, D.; Dollár, P.; and Zitnick, C. L. 2014. Microsoft coco: Common objects in context. In European Conference on Computer Vision (ECCV), 740–755. Springer]()

<div id="refer_6"></div>

- [6] [Wang, G.; Guo, J.; Chen, Y.; Li, Y.; and Xu, Q. 2019. A PSO and BFO-based learning strategy applied to faster R-CNN for object detection in autonomous driving. IEEE Access, 7:18840–18859.]()

<div id="refer_7"></div>

- [7] [Sindagi, V. A.; Oza, P.; Yasarla, R.; and Patel, V. M. 2020. Prior-based domain adaptive object detection for hazy and rainy conditions. In European Conference on Computer Vision (ECCV), 763–780. Springer.]()

<div id="refer_8"></div>

- [8] [Narasimhan, S. G.; and Nayar, S. K. 2002. Vision and the atmosphere. International Journal of Computer Vision, 48(3):233–254.]()

<div id="refer_9"></div>

- [9] [You, S.; Tan, R. T.; Kawakami, R.; Mukaigawa, Y.; and Ikeuchi, K. 2015. Adherent raindrop modeling, detectionand removal in video. IEEE Transactions on Pattern Analysis and Machine Intelligence, 38(9): 1721–1733.]()

<div id="refer_10"></div>

- [10] [Huang, S.-C.; Le, T.-H.; and Jaw, D.-W. 2020. DSNet: Joint semantic learning for object detection in inclement weather conditions. IEEE Transactions on Pattern Analysis and Machine Intelligence.]()

<div id="refer_11"></div>
    
- [11] [Hang, D.; Jinshan, P.; Zhe, H.; Xiang, L.; Xinyi, Z.; Fei, W.; and Ming-Hsuan, Y. 2020. Multi-Scale Boosted Dehazing Network with Dense Feature Fusion. In Proceedings of IEEE/CVF Conference Computer Vision Pattern Recognition (CVPR).]() 

<div id="refer_12"></div>

- [12] [Liu, X.; Ma, Y.; Shi, Z.; and Chen, J. 2019. GridDehazeNet: Attention-Based Multi-Scale Network for Image Dehazing. In Proceedings of the IEEE International Conference on Computer Vision (ICCV).]()

<div id="refer_13"></div>

- [13] [Guo, C. G.; Li, C.; Guo, J.; Loy, C. C.; Hou, J.; Kwong, S.; and Cong, R. 2020. Zero-reference deep curve estimation for low-light image enhancement. In Proceedings of IEEE/CVF Conference Computer Vision Pattern Recognition (CVPR), 1780–1789.]()

<div id="refer_14"></div>

- [14] [Chen, Y.; Li, W.; Sakaridis, C.; Dai, D.; and Van Gool, L. 2018. Domain adaptive faster r-cnn for object detection in the wild. In Proceedings of IEEE/CVF Conference Computer Vision Pattern Recognition (CVPR), 3339–3348.]()

<div id="refer_15"></div>

- [15] [Hnewa, M.; and Radha, H. 2021. Multiscale Domain Adaptive YOLO for Cross-Domain Object Detection. arXiv:2106.01483.]()

<div id="refer_16"></div>

- [17] [Zhao, Z.-Q.; Zheng, P.; Xu, S.-t.; and Wu, X. 2019. Object detection with deep learning: A review. IEEE Transactions on Neural Networks and Learning Systems, 30(11):3212–3232.]()

<div id="refer_17"></div>

- [18] [Girshick, R.; Donahue, J.; Darrell, T.; and Malik, J. 2014. Rich feature hierarchies for accurate object detection and semantic segmentation. In Proceedings of IEEE/CVF Conference Computer Vision Pattern Recognition (CVPR), 580–587.]()

<div id="refer_18"></div>

- [19] [Girshick, R. 2015. Fast r-cnn. In Proceedings of the IEEE International Conference on Computer Vision (ICCV),1440–1448.]()

<div id="refer_19"></div>

- [20] [Redmon, J.; Divvala, S.; Girshick, R.; and Farhadi, A. 2016. You only look once: Unified, real-time object detection. In Proceedings of IEEE/CVF Conference Computer Vision Pattern Recognition (CVPR), 779–788.]()

<div id="refer_20"></div>

- [21] [Redmon, J.; and Farhadi, A. 2017. YOLO9000: better, faster, stronger. In Proceedings of IEEE/CVF Conference Computer Vision Pattern Recognition (CVPR), 7263–7271]()

<div id="refer_21"></div>

- [22] [Bochkovskiy, A.; Wang, C.-Y.; and Liao, H.-Y. M. 2020. Yolov4: Optimal speed and accuracy of object detection. arXiv:2004.10934.]()

<div id="refer_22"></div>

- [23] [Liu, W.; Anguelov, D.; Erhan, D.; Szegedy, C.; Reed, S.; Fu, C.-Y.; and Berg, A. C. 2016. Ssd: Single shot multibox detector. In European Conference on Computer Vision, 21–37. Springer.]()

<div id="refer_23"></div>

- [23] [Polesel, A.; Ramponi, G.; and Mathews, V. J. 2000. Image enhancement via adaptive unsharp masking. IEEE Transactions on Image Processing, 9(3): 505–510.]()

<div id="refer_24"></div>

- [24] [Yu, Z.; and Bajaj, C. 2004. A fast and adaptive method for image contrast enhancement. In 2004 International Conference on Image Processing, 2004. ICIP’04., volume 2, 1001–1004. IEEE.]()

<div id="refer_25"></div>

- [25] [Wang, W.; Chen, Z.; Yuan, X.; and Guan, F. 2021. An adaptive weak light image enhancement method. In Twelfth International Conference on Signal Processing Systems, volume 11719, 1171902. International Society for Optics and Photonics.]()

<div id="refer_26"></div>

- [26] [Yu, R.; Liu, W.; Zhang, Y.; Qu, Z.; Zhao, D.; and Zhang, B. 2018. Deepexposure: Learning to expose photos with asynchronously reinforced adversarial learning. In Proceedings of the 32nd International Conference on Neural Information Processing Systems (NeurIPS), 2153–2163.]()

<div id="refer_27"></div>

- [27] [Zeng, H.; Cai, J.; Li, L.; Cao, Z.; and Zhang, L. 2020. Learning image-adaptive 3D lookup tables for high performance photo enhancement in real-time. IEEE Transactions on Pattern Analysis and Machine Intelligence.]()

<div id="refer_28"></div>

- [28] []()

<div id="refer_29"></div>

- [29] []()

<div id="refer_30"></div>

- [30] []()