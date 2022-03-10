
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Git 的基本使用](#git-的基本使用)
  - [安装](#安装)
  - [开始](#开始)
      - [创建仓库](#创建仓库)
      - [查看仓库状态](#查看仓库状态)
      - [添加文件](#添加文件)
      - [提交文件](#提交文件)
      - [比较文件具体变动](#比较文件具体变动)
      - [提交改动](#提交改动)

<!-- /code_chunk_output -->



# Git 的基本使用

~~其实有GitHub Desktop可以用，但是很多时候GUI软件反而不那么直观~~

## 安装
略。

---

## 开始

#### 创建仓库
在想要作为仓库的目录下，使用```git init```建立及初始化本地代码仓库
```
D:\document\git_study> git init
Initialized empty Git repository in D:/document/git_study/.git/

D:\document\git_study>ls -A
.git
```
生成了.git文件夹

#### 查看仓库状态
使用`git status`命令查看仓库所处状态
```
D:\document\git_study>echo this repository is for git study > readme.md

D:\document\git_study>git status
On branch master

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        readme.md

nothing added to commit but untracked files present (use "git add" to track)
```
命令给出了当前所在的分支`On branch master`，commit状况，以及仓库目录下文件的状况
(没有任何需要提交的添加，但是有未追踪的文件出现)

#### 添加文件
使用`git add <filename>`将该仓库目录下的文件添加到该仓库来管理
```
D:\document\git_study>git add readme.md

D:\document\git_study>git status        
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   readme.md
```
此后`git`将会观察并记录文件`readme.md`的变化
相反，使用`git rm --cached <filename>`来取消仓库对某个文件的追踪，指定`-f`参数强制执行命令

#### 提交文件
使用`git commit`提交文件，`-m`参数指定此次提交的说明信息
```
D:\document\git_study>git commit -m "create readme.md"
[master (root-commit) ce27b16] create readme.md
 1 file changed, 1 insertion(+)
 create mode 100644 readme.md
```

#### 比较文件具体变动
使用`git diff <filename>`命令查看文件内容的具体变动
```
D:\document\git_study>echo this repository is for git study. > readme.md

D:\document\git_study>git diff readme.md
diff --git a/readme.md b/readme.md
index c71e5d4..21db9fd 100644
--- a/readme.md
+++ b/readme.md
@@ -1 +1 @@
-this repository is for git study 
+this repository is for git study. 
```

#### 提交改动
此时仓库状态如下
```
D:\document\git_study>git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   readme.md

no changes added to commit (use "git add" and/or "git commit -a")
```
使用`git add`将改动添加到此次的提交，并使用`git commit`使提交生效
文件`git add`后，`git diff`将比较上次`add`操作后与当前文件内容的差异
```
D:\document\git_study>git add readme.md

D:\document\git_study>git diff readme.md

D:\document\git_study>git status        
On branch master
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   readme.md


D:\document\git_study>git commit -m "add a dot" 
[master 7685243] add a dot
 1 file changed, 1 insertion(+), 1 deletion(-)

D:\document\git_study>git status    
On branch master
nothing to commit, working tree clean
```
类似地，`git restore --staged <filename>`命令在`commit`前可取消对文件改动的`add`操作

## 分支管理

#### 查看分支

```bash
git branch
```

#### 删除分支

```bash
git branch -d $branch_name
```
