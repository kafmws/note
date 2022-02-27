### 提出的问题：

能否定义重要的领域偏移，使其对不同方法具有健壮性，并系统地衡量其健壮性？

### 基本思想

数据总能被解构为一组属性，我们期望模型能通过某个属性的某些分布学习到属性的具有不变性的部分，因而能泛化到该属性未见过的、以及在该属性上具有不同分布的样本。

文章描述了以下三种单纯、广泛存在的域偏移：

- 伪相关`spurious correlation`
> Spurious correlation – Attributes are correlated under p~train~ but not p~test~
由于选择偏见等原因，某些属性在训练集中表现出相关性，而真实数据/测试集中这些属性无关。

- 少量数据漂移`low-data drift `
> Low-data drift – Attribute values are unevenly distributed under p~train~ but not under p~test~
训练集中呈现出与真实数据/测试集不同的数量分布。

- 陌生数据`unseen data shift`
> Unseen data shift – Some attribute values are unseen under p~train~ but are under p~test~
真实数据/测试集中某些属性的取值在训练集中未出现过。

并认为更复杂的域偏移由这三个基本要素组合构成。

文中提到的增强泛化性的手段：
- 加权重采样`weighted resampling`
- 数据增强`data augmentation`
- 表征学习`representation learning`

### 评估的模型

文章比较了5个大类19种不同方法在三种域偏移下的表现评估其泛化性能，并分析了各类方法对增强泛化性的作用。并将**标签噪声**`lable noise`和**数据集大小**`dataset size`两个条件纳入考虑范围。

文章中比较的5类(architecture choice, data augmentation, domain generalization, adaptive algorithms, and representation learning)19种方法
- 架构选择`architecture choice`
> We use weighted resampling preweight to oversample from the parts of the distribution that have a lower probability of being sampled from under ptrain. ...Performance depends on how robust the learned representation is to distribution shift.
使用加权重采样过采样分布中概率较低的样本，(泛化)性能取决于学习到的特征在域偏移中的健壮性。

ResNet18、ResNet50、ResNet101  (CNN)
ViT(Transformer)
MLP(Multiple layer perceptron)

- 启发式数据增强`heuristic data augmentation`
> These approaches attempt to approximate the true underlying generative model p(x|y1:K) in order to improve robustness. ...Performance depends on how well the heuristic augmentations approximate the true generative model.
数据增强方法通过估计潜在的生成真实数据的模型提高健壮性。(泛化)性能取决于方法对真实生成模型的近似程度。

standard ImageNet augmentation
AugMix without JSD
RandAugment
AutoAugment

- 学习数据增强`learned data augmentation`
> These approaches approximate the true underlying generative model p(x|y1:K) by learning augmentations conditioned on the nuisance attribute. The learned augmentations can be used to transform any image x to have a new attribute, while keeping the other attributes fixed. ...Performance depends on how well the learned augmentations approximate the true generative model.
该方法通过学习以妨碍属性为条件的增强来近似得到潜在的真实生成模型以提高健壮性。这种增强可以将任意图片变换到新属性并保持其他属性不变。(泛化)性能取决于对真实生成模型的近似程度。

CYCLEGAN

- 域泛化`domain generalization`
> These approaches aim to recover a representation z that is independent of the attribute: p(y^a^,z) = p(y^a^)p(z) to allow generalization over that attribute. ...Performance depends on the invariance of the learned representation z. ...Performance depends on the invariance of the learned representation z.
该方法旨在恢复一个独立于属性的表征z，以便对该属性进行泛化。(泛化)性能取决于学习到的表征z的不变性。

IRM
DeepCORAL
domain MixUp
DANN
SagNet

- 适应性方法`adaptive approaches`
> These works modify p~reweight~ dynamically. We evaluate JTT (Liu et al., 2021) and BN-Adapt (Schneider et al., 2020). These methods do not give performance guarantees.
动态修正特征(样本?)权重，这类方法不保证性能。

JTT
BN-Adapt

- 表征学习`representation learning`
> These works aim to learn a robust representation of z that describes the true prior. ...Performance depends on the quality of the learned representation for the specific task.
旨在学习描述真实先验的健壮的表征z。性能取决于学习到的特定任务表征的质量。

β-VAE
pretraining on ImageNet

### Experiments
- Dataset
six vision, classification datasets:
DSPRITES
MPI3D
SMALLNORB
SHAPES3D
CAMELYON17
IWILDCAM

ResNet18 for the simpler, synthetic datasets (DSPRITES, MPI3D, SHAPES3D, and SMALLNORB)
but a ResNet50 for the more complex, real world ones (CAMELYON17 and IWILDCAM).




---

### 对于IWILDCAM数据集的`low data drift`，效果不佳，纵坐标只到0.6，其它数据集1.0，说明这里还有工作可做