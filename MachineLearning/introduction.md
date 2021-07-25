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
Arthur Samuel(1959):
> Machine learning is the field of study that gives computers the ability to learn without being explicitly programmed.


Tom Mitchell(1998):

> A computer program is said to _learn_ from experience E with respect to some task T and some performance measure P, if its performance on T, as measured by P, improves with experience E.

Example: 
> playing checkers.
>
> E = the experience of playing many games of checkers
>
> T = the task of playing checkers.
>
> P = the probability that the program will win the next game.

In general, any machine learning problem can be assigned to one of two broad classifications:

Supervised learning and Unsupervised learning.

### Types of learning algorithms

The main two types:

- supervised learning (teach computer how to do)
- unsupervised learning (let computer learn by itself)
  Others: reinforcement learning, recommender system.

One important thing is: ==use proper algorithms for an exact problem==.

#### Supervised Learning

characteristic: =="right answer" given==

- Regression: predict continous valued output
(map input variables to certain continuous function)
- Classfication: discrete valued output
(map input variables into discrete known categories)

#### Unsupervised Learning
no classfication information / same classfication information given
algorithms automatically find the structure of the dataset
So, Unsupervised learning allows us to approach problems with little or no idea what our results should look like.
- Cluster algorithm
- Non-clustering: Cocktail party algorithm
(find structure in a chaotic environment)
- ...