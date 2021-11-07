<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=5 orderedList=false} -->

<!-- code_chunk_output -->

- [运维](#运维)
    - [系统log管理，例：开启 cron 的 log](#系统log管理例开启-cron-的-log)
- [常用换源](#常用换源)
    - [Anaconda 换源](#anaconda-换源)
    - [pip 换源](#pip-换源)

<!-- /code_chunk_output -->

## 运维

#### 系统log管理，例：开启 cron 的 log

```bash
vim /etc/rsyslog.d/50-default.conf
```
取消 cron 日志的默认注释
```bash
#cron.*                          /var/log/cron.log
```
重启 rsyslog 服务
```bash
service rsyslog restart
```
重启 cron 服务
```bash
service cron restart
```

## 常用换源

#### Anaconda 换源
各系统都可以通过修改用户目录下的 .condarc 文件。Windows 用户无法直接创建名为 .condarc 的文件，可先执行 `conda config --set show_channel_urls yes` 生成该文件之后再修改。

注：由于更新过快难以同步，我们不同步pytorch-nightly, pytorch-nightly-cpu, ignite-nightly这三个包。
```bash
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
```
即可添加 Anaconda Python 免费仓库。

运行 `conda clean -i` 清除索引缓存，保证用的是镜像站提供的索引。

运行 `conda create -n myenv numpy` 测试一下吧。

#### pip 换源

- 临时使用
```bash
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package
```
注意，simple 不能少, 是 https 而不是 http

- 设为默认

升级 pip 到最新的版本 (>=10.0.0) 后进行配置：
```bash
pip install pip -U
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```
如果您到 pip 默认源的网络连接较差，临时使用本镜像站来升级 pip：
```bash
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
```