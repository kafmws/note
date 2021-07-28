# LaTex Brief
- 行内公式
```LaTex
$ f(x) $
```
这是行内公式$ f(x) $。

- 行间公式
```LaTex
$$ f(x) $$
```
$$ f(x) $$


- 手动编号
```LaTex
$$ f(x) = a - b \tag{1.1} $$
```
$$ f(x) = a - b \tag{1.1} $$

----

- 运算符
加减乘除
`$ + - * / = $`$ + - * / = $

|LaTex|符号|含义|LaTex|符号|含义|LaTex|符号|含义|
|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|
|\cdot|$\cdot$|点乘|\neq|$\neq$|不等于|\equiv|$\equiv$|恒等于/等价|
|\ge\lt|$\ge\lt$|比较运算符|\approx|$\approx$|约等于号|\propto|$\propto$|正比|
|\sim|$\sim$|相似|\bmod|$\bmod$|模|\times\div|$\times\div$|乘除|
|\pm|$\pm$|加减||\mp|$\mp$|减加|\sin{x}\arcsin{x}|$\sin{x}\arcsin{x}$|正弦反正弦|
|\log{N}\ln{N}|$\log{N} \ln{N}$|\stackrel*=|$ \stackrel*= $|二元运算符叠加符号|

- 上下标

|LaTex|示例|LaTex|示例|LaTex|示例|LaTex|示例|LaTex|示例|
|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|:----:|
|X^2|$ X^2 $|N_+|$ N_+ $|f''_{xy}(x,y)|$ f''_{xy}(x,y) $|\frac<br>\tfrac<br>\dfrac{x}{y}|$ \dfrac{x}{y} $|\sqrt[n]{...}|$ \sqrt[n]{\frac{x}{y}} $|

- 上下限运算符
`\lim_{x\to\inf}`$$ \lim_{x\to\infty} $$

$$ \sum_{\begin{subarray}{l}
    0\le i\le n \\
    j\in \mathbb{R}
\end{subarray}}^j $$

- 其他
\max
\ldots，\cdots，\vdots，\ddots \dot