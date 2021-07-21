<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=5 orderedList=false} -->

<!-- code_chunk_output -->

- [Introduction of ML](#introduction-of-ml)
  - [Machine Learning](#machine-learning)
  - [What is ML?](#what-is-ml)
  - [Types of learning algorithms](#types-of-learning-algorithms)
    - [Supervised Learning](#supervised-learning)
    - [Unsupervised Learning](#unsupervised-learning)

<!-- /code_chunk_output -->

## Introduction of ML

### Machine Learning

Examples:

- Database mining
  Large datasets
  E.g., Web click data, medical records
- Applications can't program by hand
  E.g., handwriting recognition, most of NLP, CV
- Self-customizing programs
  E.g., recommender systems

### What is ML?

Tom Mitchell(1998):

> A computer program is said to _learn_ from experience E with respect to some task T and some performance measure P, if its performance on T, as measured by P, improves with experience E.

### Types of learning algorithms

The main two types:

- supervised learning (teach computer how to do)
- unsupervised learning (let computer learn by itself)
  Others: reinforcement learning, recommender system.

One important thing is: use proper algorithms for an exact problem.

#### Supervised Learning

characteristic: =="right answer" given==

- Regression: predict continous valued output
- Classfication: discrete valued output

#### Unsupervised Learning
no classfication information / same classfication information given
algorithms find the structure of the dataset
- Cluster algorithm
- 