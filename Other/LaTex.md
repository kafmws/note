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

- 希腊字母

| 希腊字母小写、大 | LaTeX形式 | 希腊字母小写、大写 | LaTeX形式 |
|:-----:|:-----:|:-----:|:-----:|
|αα A	|\alpha A|	μμ N|	\mu N|
|ββ B	|\beta B|	ξξ ΞΞ|	\xi \Xi|
|γγ ΓΓ|	\gamma \Gamma|	o O	o O
|δδ ΔΔ|	\delta \ Delta|	ππ ΠΠ	\pi \Pi
|ϵϵ εε| E	\epsilon \varepsilon E	ρρ ϱϱ P	|\rho |\varrho P
|ζζ Z	|\zeta Z	σσ ΣΣ	\sigma \Sigma
|ηη H	|\eta H	ττ T	\tau T
|θθ ϑϑ| ΘΘ	\theta \vartheta \Theta	υυ |ΥΥ	\u|psilon \Upsilon
|ιι I	|\iota I	ϕϕ φφ ΦΦ	\phi \varphi |\Phi
||κκ K	|\kappa K	χχ X	\chi X
|λλ ΛΛ|	\lambda \Lambda	ψψ ΨΨ	\psi \Psi
|μμ M	|\mu M	ωω ΩΩ	\omega \Omega

- 其他
\max
\ldots，\cdots，\vdots，\ddots \dot

- 间距

| LaTex |  效果  |
|:-----:|:------:|
|`a\!b`|\( a\!b \)|
|`ab`|\( ab \)|
|`a\,b`|\( a\,b \)|
|`a\;b`|\( a\;b \)|
|`a\ b`|\( a\ b \)|
|`a \quad b`|\( a \quad b \)|
|`a \qquad b`|\( a \qquad b \)|
