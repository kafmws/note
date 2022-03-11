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

异构环境下对DG方法的评估，图像分类任务需要为新域的标签空间训练分类器。而像图片匹配任务，就可以直接使用学习到的特征表示。（并没有新的标签空间）


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
而在 DG 中，域偏移主要是协变量（co-variate shift, K. Muandet, D. Balduzzi, and B. Scholkopf, “Domain generalization via invariant feature representation,” in ICML, 2013.）偏移导致的，即源数据输入特征和目标数据输入特征的不同（输入变量边缘分布的改变）。

因为训练集和测试集标签空间不相交，ZSL 的通常做法是把输入图片映射到特征空间（Y. Xian, C. H. Lampert, B.  Schiele, and Z. Akata, “Zero-shot learning—a comprehensive evaluation of the good, the bad and the ugly,” TPAMI, 2018.）而非标签。但 DG 也开始利用特征来学习可在域间泛化的表征。（C. Gan, T. Yang, and B. Gong, “Learning attributes equals multi-
source domain generalization,” in CVPR, 2016.）

有工作研究了 $ P_X $ 和 $ P_Y $ 同时变化的情况，即 ZSL + DG ==和野生动物识别的情况很像==
（M. Mancini, Z. Akata, E. Ricci, and B. Caputo, “Towards recognizing unseen categories in unseen domains,” in ECCV, 2020.）

- 域适应（Domain Adaption, DA）:

DA 和 DG 最为接近，也像 DG 一样得到广泛关注。DA 假设目标域的边缘分布 $ P_X $ 是可用的，无论是否标注。尽管存在许多 DA 的变体可能在训练期间没有明确使用目标数据，但使用目标域数据的基本思想没有改变。如 zero-shot DA，利用与任务无关但目标域相关的数据（仍然是目标域的分布可获取）。

DA 与 DG 存在许多共性，如 single-source DA, multi-source DA, heterogeneous DA.

## 方法（Methodology）：
大多数现有的 DG 方法为 multi-source 域泛化设计，尽管一些方法没有明确要求域标签，因此也可以作为单源域泛化方法。

