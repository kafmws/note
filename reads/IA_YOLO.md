<!-- @import "[TOC]" {cmd="toc" depthFrom=3 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Tittle](#tittle)
- [Date & Source](#date-source)
- [Abstract](#abstract)
- [Introduction](#introduction)
- [相关工作](#相关工作)
  - [目标检测](#目标检测)
- [References](#references)

<!-- /code_chunk_output -->

### Tittle

Image-Adaptive YOLO for Object Detection in Adverse Weather Conditions

恶劣天气下的目标检测模型图像自适应 YOLO

### Date & Source

arXiv:2112.08088 v1
AAAI 2022 ZJU

### Abstract

&emsp;&emsp;即使在传统数据集上基于深度学习的目标检测方法已经取得了可观的效果，在恶劣天气条件下拍摄的低质量图片中定位目标仍是具有挑战性的。已存在的方法要么难以平衡图像增强和目标检测任务，要么常常忽视对检测有益的潜在信息。为缓解这一问题，我们提出了一个新的图像自适应 YOLO (Image-Adaptive YOLO, IA-YOLO)框架，其中每张图像都可以自适应地增强以取得更好的检测效果。特别地，考虑到 YOLO 检测器面临的恶劣天气条件， 我们提出了一个可微图像处理(differentiable image processing, DIP)模块，该模块的参数使用一个称为 CNN-PP 的小规模卷积神经网络预测得到。我们以一种端到端的方式共同训练 CNN-PP 和 YOLOv3，这以一种弱监督的方式保证了 CNN-PP 能学习到一个合适的 DIP 来为目标检测增强图片。我们提出的 IA-YOLO 方法可以自适应地处理正常和恶劣天气条件下的图片。实验结果是非常令人鼓舞的，在有雾和低光照场景中证明了 IA-YOLO 有效性。源代码开放在 https://github.com/wenyyu/ImageAdaptive-YOLO。


### Introduction

&emsp;&emsp;在目标检测中基于 CNN 的方法已经变得非常流行 [<sup>[1]</sup>](#refer_1) [<sup>[2]</sup>](#refer_2)。他们不仅在基准数据集上实现了令人满意的效果 [<sup>[3]</sup>](#refer_3) [<sup>[4]</sup>](#refer_4) [<sup>[5]</sup>](#refer_5)，并且已经部署到实际应用中如自动驾驶 [<sup>[6]</sup>](#refer_6)。由于输入图像的领域偏移 [<sup>[7]</sup>](#refer_7) 高质量图片训练出的一般目标检测模型通常在恶劣天气条件下（如雾天和低光照）难以获得令人满意的结果。Narasimhan 和 Nayar [<sup>[8]</sup>](#refer_8) 还有 You [<sup>[9]</sup>](#refer_9) 提出恶劣天气下获取的图像可以被分解为清晰的图片和相应的特定天气信息，并且恶劣天气下图像质量退化主要由于特定天气信息和目标的相互作用造成，这导致了不理想的检测效果。[图1](#fig_1)展示了一个雾霭条件下的目标检测示例。可以看出如果图片根据天气情况被适当增强，则可以恢复原始模糊目标和误判的目标的更多潜在信息。

<img src="https://cdn.jsdelivr.net/gh/kafmws/pictures/notes/20220104224520.png" alt="20220104224520" style="clear:both;display:block;margin:auto;" width="80%" id="fig_1">

> Figure 1: In the real-world foggy condition, our method can adaptively output clearer images with sharper edges around objects’ boundary, and consequently produce higher confidence detection results with fewer missing instances.
图1，在真正的雾天中，我们的方法可以自适应地输出更清晰，边缘更鲜明的目标边界图像，从而在更少缺失目标实体的情况下产生更高置信度的检测结果。

&emsp;&emsp;为了解决这个具有挑战性的问题，Huang, Le 和 Jaw [<sup>[10]</sup>](#refer_10) 使用两个子网络共同学习可见性增强和目标检测，通过共享特征提取层来减少图像退化的影响。然而，在训练过程中很难调整参数来平衡检测和恢复之间的权重。另一种方案是使用现有方法如去雾 [<sup>[11]</sup>](#refer_11) [<sup>[12]</sup>](#refer_12) 和图像增强 [<sup>[13]</sup>](#refer_13) 预处理图像以减轻特定天气信息的影响。然而这些方法不得不包含复杂的、需要用像素级监督学习单独训练的图像恢复网络，需要手动标注要恢复的图像。这也可以视为无监督的领域适应任务 [<sup>[14]</sup>](#refer_14) [<sup>[15]</sup>](#refer_15)。相对于用清晰图像（源图像）训练分类器，假定恶劣天气下捕获的图像（目标图像）存在分布迁移(distribution shift)。这些方法主要采用域适应原理并聚焦于两种分布的特征对齐，基于天气的图像恢复过程中可能获得的潜在信息往往被忽略了。

&emsp;&emsp;为了克服以上局限性，我们提出了一个巧妙的自适应目标检测方法，称为 IA-YOLO。确切地说，我们提出一个全可微的图像处理模块(DIP)，它的超参数由一个基于 CNN 的小规模参数预测器(CNN parameter predictor, CNN-PP)自适应地学习得到。CNN-PP 根据输入图片的亮度、色彩、色调和特定天气信息自适应地预测 DIP 的超参数。DIP 处理后的图片可以抑制特定天气信息的干扰并恢复潜在的信息。我们提出了一个共同优化计划以端到端的方式来学习 DIP, CNN-PP 和 YOLOv3 骨干检测网络 [<sup>[16]</sup>](#refer_16) 。为了增强所检测的图片，CNN-PP 通过边界框标注弱监督地学习一个适当的 DIP。此外，我们充分利用了正常和恶劣天气的图像来训练提出的网络。通过利用 CNN-PP 网络，我们提出的 IA-YOLO 方法能够自适应地处理不同程度的天气状况影响的图片。[图1](#fig_1)展示了我们提出的方法检测结果的一个示例。

&emsp;&emsp;该工作的亮点在于：1) 提出了一个图像自适应的检测框架，在普通和恶劣天气条件下都实现了令人满意的效果。2) 提出了一个白盒可微图像处理模块，其超参数是由弱监督参数预测网络所预测的。3) 与以前的方法相比，在合成测试集(synthetic testbeds)（VOC_Foggy 和 VOC_Dark）和真实数据集(real-world datasets)（RTTS 和 ExDark）上得到了振奋人心的实验结果。

### 相关工作

#### 目标检测

&emsp;&emsp;目标检测作为计算机视觉(Computer Vision, CV)的一项基本任务受到了密切关注。目标检测方法可以被粗略地分为两类 [<sup>[17]</sup>](#refer_17)。一类是基于区域建议(region proposal)的方法 [<sup>[18]</sup>](#refer_18) [<sup>[19]</sup>](#refer_19) [<sup>[2]</sup>](#refer_2)，首先
















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

- [16] [Redmon, J.; and Farhadi, A. 2018. Yolov3: An incremental improvement. arXiv:1804.02767.]()

<div id="refer_17"></div>

- [17] [Zhao, Z.-Q.; Zheng, P.; Xu, S.-t.; and Wu, X. 2019. Object detection with deep learning: A review. IEEE Transactions on Neural Networks and Learning Systems, 30(11):3212–3232.]()

<div id="refer_18"></div>

- [18] [Girshick, R.; Donahue, J.; Darrell, T.; and Malik, J. 2014. Rich feature hierarchies for accurate object detection and semantic segmentation. In Proceedings of IEEE/CVF Conference Computer Vision Pattern Recognition (CVPR), 580–587.]()

<div id="refer_19"></div>

- [19] [Girshick, R. 2015. Fast r-cnn. In Proceedings of the IEEE International Conference on Computer Vision (ICCV),1440–1448.]()

<div id="refer_20"></div>

- [20] []()

<div id="refer_21"></div>

- [21] []()

<div id="refer_22"></div>

- [22] []()

<div id="refer_23"></div>

- [23] []()

<div id="refer_24"></div>

- [24] []()

<div id="refer_25"></div>

- [25] []()