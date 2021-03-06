# Begin

域泛化问题于2011年第一次被提出。（G. Blanchard, G. Lee, and C. Scott, “Generalizing from several related classification tasks to a new unlabeled sample,” in NeurIPS, 2011.）
术语`domain generalization`由（K. Muandet, D. Balduzzi, and B. Scholkopf, “Domain generaliza-
tion via invariant feature representation,” in ICML, 2013.）创造

许多统计学习算法基于一个过于简化的假设：训练数据和目标数据独立同分布（independent identical distribution, i.i.d），然而实际应用中真实数据往往是分布在不同的域（out of distribution, OOD）。

## deal with domain shift

1.一个直观的绕过OOD问题方法的是，从目标域中收集数据，调整模型适应目标域。
局限性：目标域的数据可获取、易于获取。

2.域对齐（domain alignment）
将域不变(domain invariant)特征对齐到源域
（H. Li, S. Jialin Pan, S. Wang, and A. C. Kot, “Domain generalization with adversarial feature learning,” in CVPR, 2018.）
（Y. Li, X. Tiana, M. Gong, Y. Liu, T. Liu, K. Zhang, and D. Tao, “Deep domain generalization via conditional invariant adversarial networks,” in ECCV, 2018.）

3.元学习（meta-learning）
在训练过程中将模型暴露给域偏移
（D. Li, Y. Yang, Y.-Z. Song, and T. M. Hospedales, “Learning to generalize: Meta-learning for domain generalization,” in AAAI, 2018.）
（Y. Balaji, S. Sankaranarayanan, and R. Chellappa, “Metareg: Towards domain generalization using meta-regularization,” in NeurIPS, 2018.）

4.使用合成数据进行数据增强
（K. Zhou, Y. Yang, T. Hospedales, and T. Xiang, “Learning to generate novel domains for domain generalization,” in ECCV, 2020.）
（K. Zhou, Y. Yang, T. M. Hospedales, and T. Xiang, “Deep domain-adversarial image generation for domain generalisation.” in AAAI, 2020.）

5.集成学习（ensemble learning）

## common domain generalization benchmark dataset

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/域泛化相关数据集.png" alt="域泛化相关数据集" width="100%">


## 域泛化（Domain generalization, DG）

域泛化的目的是，使用单一域或多个相关但不同域的数据学习到可以很好地推广到任何不同域的模型。
与域适应和迁移学习相比，域泛化考虑的是**目标域数据不可用**的情形。

- single-source DG 单源域泛化 和 multi-source DG 多源泛化

single-source DG: 源数据来源于单个分布，单源域泛化与`OOD robustness`密切相关（OOD robustness 研究图像损坏情况下的模型鲁棒性）
multi-source DG: 源数据来源于多个相关联但不同的分布

现存的单源域泛化方法实际上并不考虑源数据是否来自于多个域，而是一种更通用的OOD泛化方案，实验往往包括单源和多源数据集，因此也可以应用到多源域泛化场景。

## 域泛化方法的评估

`leave-one-domain-out`，将至少包含两个域的数据集按域分隔开，使用一些域作为训练数据，在训练数据以外的域进行评估。也有一些方法在与源域标签空间不同的目标域上评估（heterogeneous DG）。

同构 DG ：源域与目标域的标签空间相同
异构 DG ：源域与目标域的标签空间不同

异构环境下对DG方法的评估，图像分类任务需要为新域的标签空间训练分类器。而像图片匹配任务，就可以直接使用学习到的特征表示（因为并没有新的标签空间）。


## DG 常用数据集

1.手写数字识别数据集
2.目标检测数据集

- 在环境(environment, background)和视角(viewpoint)上的变化
- 图片风格的变化（photo, painting, quickdraw）
- 大规模合成数据集 -> 真实图像（以迁移学习的角度，将在大规模数据集上预训练的模型，微调到目标域上）
- 使用高斯噪声和运动模糊来合成图像也被用作模拟域偏移。（受对模型对抗攻击的启发）

3.行为识别
4.语义分割
5.行人重识别
6.人脸识别
7.人脸反欺骗


野生动物有关的域泛化数据集：
TerraInc: size:24,788  domains:4    Captured at different geographical locations
(S. Beery, G. Van Horn, and P. Perona, “Recognition in terra incognita,” in ECCV, 2018.)
WILDS: 包含域偏移和野生动物。
(P. W. Koh, S. Sagawa, H. Marklund, S. M. Xie, M. Zhang, A. Balsubramani, W. Hu, M. Yasunaga, R. L. Phillips, S. Beery, J. Leskovec, A. Kundaje, E. Pierson, S. Levine, C. Finn, and P. Liang, “Wilds: A benchmark of in-the-wild distribution shifts,” arXiv preprint arXiv:2012.07421, 2020.)

## 域泛化与相关领域的比较

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/域泛化与相关领域的比较.png" alt="域泛化与相关领域的比较" width="80%">

- 监督学习（Supervised Learning）：

通过最小化损失学习到一个从输入到输入的映射 $f$ 。这个损失由 $f(x)$ 和 $y$ 计算，$x$ 为样本，$y$ 为标签，且 $(x,y)$ 服从经验分布 $\hat{P}(x,y)$ （采集到的数据、训练数据）而非真实分布 $P(x,y)$ （认为真实分布无法获取，数据集都是带有偏见的）。希望借由 $\hat{P}(x,y)$ 学习到 $P(x,y)$ ，严重地依赖于iid假设。和 DG 的关键区是训练数据和测试数据是否来自相同的域。

- 多任务学习（Multi-Task Learning, MTL）：

通过单一模型同时学习多个相关联的任务。和 DG 的区别域 SL 类似。
许多 MTL 的范式尤其是自监督学习的方法已经被运用到解决 DG 问题中。
有观点认为：MTL 方法受益于权重共享带来的正则化效果，因此也可以应用于 DG。（Y. Yang and T. Hospedales, “Deep multi-task representation learning: A tensor factorisation approach,” in ICLR, 2017.）

- 迁移学习（Transfer learning, TL）：

迁移学习的目标是把从一个或多个任务/问题/域中学习到的知识迁移到一个不同或相关的任务/问题/域上。（S. J. Pan and Q. Yang, “A survey on transfer learning,” TKDE, 2009.）
当代深度学习中 TL 的范例是微调：先在大规模数据集上预训练模型，然后在下游任务上微调（fine-tune）。
通常认为预训练学习到的特征具有高度的可迁移性。（J. Yosinski, J. Clune, Y. Bengio, and H. Lipson, “How transferable are features in deep neural networks?” in NeurIPS, 2014.）（J. Donahue, Y. Jia, O. Vinyals, J. Hoffman, N. Zhang, E. Tzeng, and T. Darrell, “Decaf: A deep convolutional activation feature for generic visual recognition,” in ICML, 2014.）

TL 和 DG 的关键区别在于目标数据是否可用。相同之处在于源域目标域来自不同分布，且 TL 主要考虑源域和目标域标签空间不相交的情况，DG 既考虑相交（同构 DG）（==同类别==）也考虑不相交的标签空间（异构 DG）。（==新类别==）

- 零样本学习（Zero-Shot Learning, ZSL）：

ZSL 和 DG 目标都是处理未知的分布。
但 ZSL 的域偏移主要由标签空间的变化（$P_Y$）导致（C. H. Lampert, H. Nickisch, and S. Harmeling, “Attribute-based classification for zero-shot visual object categorization,” TPAMI, 2014.），其主要任务是==识别新类别==，广义上的 ZSL既识别旧类别又识别新类别（W.-L. Chao, S. Changpinyo, B. Gong, and F. Sha, “An empirical study and analysis of generalized zero-shot learning for object recognition in the wild,” in ECCV, 2016. ==野生动物相关==）
而在 DG 中，域偏移主要是协变量（co-variate shift, K. Muandet, D. Balduzzi, and B. Scholkopf, “Domain generalization via invariant feature representation,” in ICML, 2013.）偏移导致的，即源数据输入特征和目标数据输入特征的不同（输入变量边缘分布的改变，而一般不考虑新的标签，$ Y $ 的改变）。

因为训练集和测试集标签空间不相交，ZSL 的通常做法是把输入图片映射到特征空间（Y. Xian, C. H. Lampert, B.  Schiele, and Z. Akata, “Zero-shot learning—a comprehensive evaluation of the good, the bad and the ugly,” TPAMI, 2018.）而非标签。但 DG 也开始利用特征来学习可在域间泛化的表征。（C. Gan, T. Yang, and B. Gong, “Learning attributes equals multi-
source domain generalization,” in CVPR, 2016.）

有工作研究了 $ P_X $ 和 $ P_Y $ 同时变化的情况，即 ZSL + DG ==和野生动物识别的情况很像==
（M. Mancini, Z. Akata, E. Ricci, and B. Caputo, “Towards recognizing unseen categories in unseen domains,” in ECCV, 2020.）

- 域适应（Domain Adaption, DA）:

DA 和 DG 最为接近，也像 DG 一样得到广泛关注。DA 假设目标域的边缘分布 $ P_X $ 是可用的，无论是否标注。尽管存在许多 DA 的变体可能在训练期间没有明确使用目标数据，但使用目标域数据的基本思想没有改变。如 zero-shot DA，利用与任务无关但目标域相关的数据（仍然是目标域的分布可获取）。

DA 与 DG 存在许多共性，如 single-source DA, multi-source DA, heterogeneous DA.

## 方法（Methodology）：
大多数现有的 DG 方法为 multi-source 域泛化设计，尽管一些方法没有明确要求域标签，因此也可以作为单源域泛化方法。

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/overview of methodology in DG.png" alt="overview of methodology in DG" width="80%">

1. 域对齐（domain alignment）

大多数现有的 DG 方法属于域对齐，中心思想是最小化源域间的差异以学习域不变表征。认为相对于源域间的偏移具有不变性的特征，其不变性在任何未见过的目标域上也具有健壮性。（需要域标签）

为了衡量域之间的距离以进行对齐，产生了许多统计距离指标，如 $l_2$ 距离，$f$-divergences，更复杂的 `Wasserstein distance`等等。

DG 中一个普遍的假设域偏移仅仅是输入数据边缘分布 $ P(X) $ 的改变，而 $ P(Y|X) $ 是相对稳定的，因此许多域对齐方法集中注意力于对齐源域的边缘分布。

2. 元学习（meta learning）

使用二阶导数？

3. 数据增强（data augmentation）

图片风格可以在 CNN 特征统计中观察到。MixStyle 混合不同域的实例的 CNN 特征统计以实现风格增强。Mixup 也被用于在像素和特征级别上混合不同域实例。（==特征解耦或许是可行的==）


4. 集成学习（ensemble learning）

Weight averaging 可作为一种后处理方法增强泛化性。

5. 自监督学习（self-supervised learning）

自监督学习并非没有标签，可以对图像做一些变换作为标签，使模型预测所做的变换来进行学习。直观上看，这种预处理与具体任务无关，因此可以学习到一些通用特征。

常用的自监督方法：预测拼图顺序(jigsaw)、旋转角度、重构：使用自动编解码器编码提取图像特征，解码重建图片。

现有的基于自监督的域泛化研究集中于目标检测任务。并且通常预处理方法都是基于特定问题选择的，暂时没有通用的预处理方法。例如，目标域的偏移若与旋转相关，而通过旋转预测任务进行预训练的模型偏向于捕获旋转敏感的信息，不利于泛化。

近期的自监督SOTA往往结合了数据增强进行对比学习，核心想法是对同一图片的不同变换（如反转，颜色失真）进行判定并希望模型排除不同的图片，从而学习到识别感知到图片实例的表征。

与预测旋转变换等预处理不同，对比学习旨在学习与具体变换无关的表征。假设对比学习得到的不变特征可以更好地适应OOD数据。

6. 特征解耦（feature disentanglement）
相较于迫使整个模型或特征表示变成域无关的，可以弱化这个目标，期望学习到解耦的特征，一部分特征是域特定的，一部分是域无关的。现有方法包括分解和生成。都需要域标签。

分解：①实现解耦的表征学习的直观做法是将模型分为域相关和域无关的两部分，当处理未知域时只使用域无关部分。②设计作用于特征向量的域特定的二进制掩码，以区分域相关特征和域无关特征。③对模型权重矩阵进行低秩分解以更好地获得泛化特征。

生成：使用生成模型（X. Chen, Y. Duan, R. Houthooft, J. Schulman, I. Sutskever, and P. Abbeel, “Infogan: Interpretable representation learning by information maximizing generative adversarial nets,” in NeurIPS, 2016.）。①利用变分自动编码器（variational autoencoder, VAE）独立地学习类、域和对象三个潜在的子空间。（M. Ilse, J. M. Tomczak, C. Louizos, and M. Welling, “Diva: Domain invariant variational autoencoder,” in ICLR-W, 2019.）②两个独立的编码器以对抗的方式学习，分别捕获身份和域信息。（G. Wang, H. Han, S. Shan, and X. Chen, “Cross-domain face presentation attack detection via multi-domain disentangled representation learning,” in CVPR, 2020.）

7. 正则化策略（Regularization strategies）（施加约束、惩罚）

①有观点认为可泛化的特征应该是全局的结构或形状，而非局部的块或纹理，因此提出抑制CNN的块状预测能力（最大化块状结构的分类错误）。（H. Wang, Z. He, Z. C. Lipton, and E. P. Xing, “Learning robust representations by projecting superficial statistics out,” in ICLR, 2019.）
②减弱占主导地位的特征对模型影响的强度，从而迫使模型更多地依赖剩余的特征以增强泛化性。（Z. Huang, H. Wang, E. P. Xing, and D. Huang, “Self-challenging improves cross-domain generalization,” in ECCV, 2020.）

正则策略不使用域标签，并且通常可以结合其他域泛化方法使用。

## 潜在研究方向

### Model Architecture

- 动态架构（Dynamic Architecture）
通常提取特征的 CNN 权重在训练完成后就不再更新，可能会使模型的表征能力限制在见过的域上。
一种方法是训练动态结构（Y. Han, G. Huang, S. Song, L. Yang, H. Wang, and Y. Wang, “Dynamic neural networks: A survey,” arXiv preprint arXiv:2102.04906, 2021）使用动态过滤网络（X. Jia, B. De Brabandere, T. Tuytelaars, and L. Van Gool, “Dynamic filter networks,” in NeurIPS, 2016.）或条件卷积（B. Yang, G. Bender, Q. V. Le, and J. Ngiam, “Condconv: Conditionally parameterized convolutions for efficient inference,” in NeurIPS, 2019.）等使CNN参数部分或全部地依赖于输入，并保证模型大小合适。

- 自适应归一化层（Adpative Normalization Layers）
以往归一化层都是根据训练数据进行归一化，可能不适用于新域，需要自适应化。

### Learning

- 无域标签学习（Learning without Domain Labels）
许多数据难以判定所属的域，而许多DG方法需要域标签。has studied but not well studied

- 新域合成学习（Learning to Synthesize Novel Domains）
源域的多样性极大地有利于提升 DG 方法的性能（K. Xu, M. Zhang, J. Li, S. S. Du, K.-I. Kawarabayashi, and S. Jegelka, “How neural networks extrapolate: From feedforward to graph neural networks,” in ICLR, 2021.）。但是实际上难以收集到所有可能存在的域，因此需要学习如何合成新域。
风格迁移（K. Zhou, Y. Yang, Y. Qiao, and T. Xiang, “Domain generalization with mixstyle,” in ICLR, 2021.）
生成新域（K. Zhou, Y. Yang, T. Hospedales, and T. Xiang, “Learning to generate novel domains for domain generalization,” in ECCV, 2020.）

- 避免捷径学习（Avoiding Learning Shortcut）
捷径学习即学习到了数据的一些“简单”表征，在训练数据上表现良好但同任务无关。即模型过于依赖数据集一些误导性的偏见或分布特点导致偏离了真实数据的特征，这些偏见仅在已有的数据上有效。多源DG中这个问题可能更严重，模型可能会简单地学习不同域的偏见如图像样式来区分实例来自的域，而非真实特征。捷径学习在DG中常常被忽略。

- 因果表征学习（Causal Representation Learning）
目前，在 DG 以及许多其他领域中表征学习的通用流程是从边缘分布 $ P(X) $ 中采样数据来学习映射 $ P(Y |X) $，目标是通过 $ P(X,Y) = P(Y|X)P(X) $ 匹配联合分布（通常使用最大似然优化）。然而事实证明，这种表征学习缺乏适应 OOD 数据的能力，一个潜在的解决方案是对潜在的因果变量进行建模（例如使用自动编码器），这些变量无法直接观察到，但在分布偏移下更加稳定和稳健。（Y. Bengio, T. Deleu, N. Rahaman, R. Ke, S. Lachapelle, O. Bilaniuk, A. Goyal, and C. Pal, “A meta-transfer objective for learning to disentangle causal mechanisms,” arXiv preprint arXiv:1901.10912, 2019.）。

- 利用辅助信息（Exploiting Side Information）

使用一些域不敏感的信息（颜色、形状、条纹），这里与某些文章的全局特征可能有些冲突。

使用“属性（attribute）”
（C. H. Lampert, H. Nickisch, and S. Harmeling, “Attribute-based classification for zero-shot visual object categorization,” TPAMI, 2014）
（Y. Xian, C. H. Lampert, B. Schiele, and Z. Akata, “Zero-shot learning—a comprehensive evaluation of the good, the bad and the ugly,” TPAMI, 2018.）

- 迁移学习（Transfer Learning）

合成到真实的迁移学习是一种现实且实用的方法，但有待进一步研究。在合成数据集上适应下游任务时，保持预训练时从真实图像上获得的知识。与  learning-without-forgetting (LwF) 密切相关。一种技术是，最小化新模型输出与旧模型输出直接的差异，以避免擦除预训练的知识。

- 半监督中的域泛化（Semi-Supervised Domain Generalization）

许多DG方法假设数据具有标注，因此完全基于监督学习。有半监督学习通过伪标签利用未标注数据。
这样利用更多数据辅以DG方法提升泛化性能。

- 开放域泛化（Open Domain Generalization）

一种新的情景，多源域异构DG，源域标签空间不同但有重叠，需要识别目标域中的已知类别，使用置信度辨别未知类别并拒绝。
并提出了一种在特征和标签层次进行数据增强的 Mixup 变体。
（Y. Shu, Z. Cao, C. Wang, J. Wang, and M. Long, “Open domain generalization with domain-augmented meta-learning,” in CVPR, 2021.）

### Benchmarks

可以继续研究的 benchmark：

增量学习 + DG（Incremental Learning + DG）：大多数现有DG方法隐式地假定源域是固定的并且模型只需要训练一次。但实际情况中源域可能在不断增长。有以下几个问题需要考虑：①如何在新数据集/域上有效微调模型而避免使用全部数据集重新训练。②如何确保模型不在新数据集上过拟合，并且不遗忘已有的知识。③新数据集/域对目标域的泛化性能是有益还是有害？

异构域偏移（Heterogeneous Domain Shift）：当前DG数据集主要是同构域偏移，源域之间和源域与目标域之间的域偏移高度相关。真实世界的域偏移往往比当前的数据集更复杂。目前异构域偏移的情景还从未被提出及研究。
