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
与域适应和迁移学习相比，域泛化考虑的是目标域数据不可获取的情形。