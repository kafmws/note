域泛化问题于2011年第一次被提出。（G. Blanchard, G. Lee, and C. Scott, “Generalizing from several related classification tasks to a new unlabeled sample,” in NeurIPS, 2011.）
术语`domain generalization`由（K. Muandet, D. Balduzzi, and B. Scholkopf, “Domain generaliza-
tion via invariant feature representation,” in ICML, 2013.）创造

许多统计学习算法基于一个过于简化的假设：训练数据和目标数据独立同分布（independent identical distribution, i.i.d），然而实际应用中真实数据往往是分布在不同的域（out of distribution, OOD）。

## deal with domain shift

1.一个直观的绕过OOD问题方法的是，从目标域中收集数据，调整模型适应目标域。
- 局限性：目标域的数据可获取、易于获取。

2.域对齐
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


## 域泛化（Domain generalization, DG）

域泛化的目的是，使用单一域或多个相关但不同域的数据学习到可以很好地推广到任何不同域的模型。
与域适应和迁移学习相比，域泛化考虑的是**目标域数据不可用**的情形。

- single-source DG 单源域 和 multi-source 多源域
single-source DG: 源数据来源于多个相关联但不同的分布
multi-source DG: 源数据来源于单个分布，单源域泛化与`OOD robustness`密切相关（OOD robustness 研究图像损坏情况下的模型鲁棒性）

现存的单源域泛化方法实际上并不考虑源数据是否来自于多个域，而是一种更通用的OOD泛化方案，实验往往包括单源和多源数据集，因此也可以应用到多源域泛化场景。

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/域泛化与相关领域的比较.png" alt="域泛化与相关领域的比较" width="80%">

## 域泛化方法的评估

`leave-one-domain-out`，将至少包含两个域的数据集按域分隔开，使用一些域作为训练数据，在训练数据以外的域进行评估。也有一些方法在与源域标签空间不同的目标域上评估（heterogeneous DG）。

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


WILDS: 包含域偏移和野生动物。