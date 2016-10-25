Linear Bandits
========================================================
author: Lin & James
date: 

Linear Bandit Set-up
========================================================
- Generalization of **Adversarial Bandits**
  * Set of arms {1, ... ,K} $\rightarrow$ compact set $\mathcal{K} \subset \mathbb{R}^d$. Loss is a linear function of arms.  
  
- **Parameters available to the player**:
  * Number of rounds $n$
  * Action set of the player $\mathcal{K}\subset \mathbb{R}^d$
  * Action set of the adversary $\mathcal{L}\subset \mathbb{R}^d$
  
Linear Bandit Set-up
=================================================================
- **Game**: At each round $t = 1,2,\dots,n$
  1. Player choose $x_t \in \mathcal{K}$
  2. Adversary choose $l_t \in \mathcal{L}$
  3. At the end of round $t$, player observe loss $\langle x_t,l_t\rangle=x_t^Tl_t$
- **Pseudo-regret**
$$
\bar{R}_n = \mathbb{E}\sum_{t=1}^n x_t^Tl_t - \underset{x\in\mathcal{K}}{\mathrm{min}}\mathbb{E}\sum_{t=1}^n  x^Tl_t
$$
(Expectation with respect to the forecaster's internal randomization)  

Example: Obstacle Course Problem
=================================================================
![alt text](obsticalcourse.jpg)


Challenge: 5,000 kids to $5,000
=================================================================
- 33 obstacles with varying difficulty levels 
- Each kid must complete 5
- Sending one kid at a time you choose their path
- 81 different paths
- Each path is a linear combination of 5 obstacles
- **Fastest team wins!**

Strategy: Exp2 with John's Exploration
=================================================================
Need a non-deterministic strategy to play against the adversary.  
- **Exp**anded **Exp**onential with John's Exploration
- **Bounded scalar loss** assumption:
  1. $\mathcal{K}$ and $\mathcal{L}$ are such that $\lvert x^Tl \rvert \le 1, \forall (x,y)\in \mathcal{K}\times \mathcal{L}$
  2. $\mathcal{K}$ is finite with $\lvert \mathcal{K}\rvert = N$ and $\mathcal{K}$ spans $\mathbb{R}^d$
- John Ellipsoid $\mathcal{E}$
  * The John ellipsoid associated to a convex set $\mathcal{K} \subset\mathbb{R}^d$ is the ellipsoid of minimal $d$-dimensional volume enclosing $\mathcal{K}$.

John's Theorem
========================================================
- **Theorem 5.1**.  Let $\mathcal{K} \subset\mathbb{R}^d$ be a convex set. If the John ellipsoid $\mathcal{E}$ is the **unit ball** in some norm derived from a scalar product $\langle\cdot,\cdot\rangle$, then there exist $M \le d(d+1)/2+1$ **contact points** $u_1,\dots,u_M$ between $\mathcal{K}$ and $\mathcal{E}$, and a **probability distribution** $(\mu_1,\dots,\mu_M)$ over these contact points such that 
$$
x = d \sum_{i=1}^{M}\mu_i u_i \otimes u_i (x)
$$
- (**Outer product**:  $x\otimes x(y) = \langle x,y\rangle x$)  

The key idea is **select $x_t$ at random** from some **prob. dist. $p_t$** over $\mathcal{K}$. Since we do not directly observe $l_t$, we need to find an estimate for it.

Strategy: Exp2 with John's Exploration
========================================================
- Define a $d \times d$ matrix
$$
P_t = \sum_{x\in\mathcal{K}}p_t(x) x \otimes x
$$
- Unbiased estimate of $l_t$: $\tilde{l}_t = P_t^{-1}(x_t\otimes x_t)l_t$  
*Proof:*   
$$
\begin{aligned}
\mathbb{E}(\tilde{l}_t) &= \mathbb{E}(P_t^{-1}(x_t\otimes x_t)l_t)\\
 &= P_t^{-1} \mathbb{E}(x_t\otimes x_t) l_t \\
 &= P_t^{-1} [\sum_{x\in\mathcal{K}}p_t(x) x \otimes x] l_t \\
 &= P_t^{-1} P_t l_t = l_t
\end{aligned}
$$

Exp2 with John's Exploration
========================================================
Input parameters $\eta,\gamma > 0$:  
For each round $t = 1, 2, \dots, n$:  
  1. Player select $x_t$ from $p_t$.  
  2. Compute the estimate of $l_t$  
  $$\tilde{l}_t = P_t^{-1}(x_t\otimes x_t)l_t$$
  Update the cummulative loss:
  $\tilde{L}_t(x) = \sum_{s=1}^{t}\langle x_,\tilde{l}_s\rangle$  
  3. Update the probability distribution over $x \in \mathcal{K}$:
  $$
  p_{t+1}(x) = (1-\gamma)\frac{\mathrm{exp}[-\eta \tilde{L}_t(x)]}{\sum_{y\in \mathcal{K}}\mathrm{exp}[-\eta \tilde{L}_t(y)]}+\gamma\sum_{i=1}^{M}\mu_i \mathbb{1}_{x=u_i}
  $$
Pseudo-regret of Exp2-John
========================================================
(**Thm 5.2**) . For any $\eta,\gamma > 0$ such that $\eta d\le\gamma$, Exp2 with John's exploration satisfies
$$
\bar{R_n} \le 2\gamma n + \frac{\mathrm{ln}(N)}{\eta} + \eta nd
$$
When $\eta = \sqrt{\frac{\mathrm{ln}(N)}{3nd}}$ and $\gamma = \eta d$,
$$
\bar{R_n} \le 2\sqrt{3nd\mathrm{ln}{N}}
$$

*Proof*: See the script.
