# Synthetic Denoising Experiment

Synthetic denoising experiment for the JFRT paper.

## Dependencies

This experiment depends on the [Graph Signal Processing toolbox of EPFL](https://epfl-lts2.github.io/gspbox-html/). Installation instructions can be found on their page. However, this not a regular toolbox that you can download from _Add-on Manager_, so you have to add the path of installation and start the toolbox before accessing it. After initial installation and build process, following snippet needs to be in the scripts that you access the toolbox, where you need to change `</path/to/gsp/toolbox>` with the installation path on your machine.

```matlab
addpath("</path/to/gsp/toolbox>");
gsp_start;
```

## Notes for Experiment Details

General structure of the JTV signal definition and lowpass filtering is designed based on the traditional lowpass filtering. On top of sinusoidal signals, Gaussian random or another high frequency sinusoidal is generated as additive noise. Based on the definition JFRT, optimal values of $\alpha$ and $\beta$ has been selected according to the selected error. Error surface with respect to tested $\alpha$ and $\beta$ values is also generated.

### Graph Generation

Graph generation is handled with [Graph Signal Processing toolbox of EPFL](https://epfl-lts2.github.io/gspbox-html/). It contains `gsp_sensor(N)` and `gsp_david_sensor_network(N)` functions for sensor network generation. Weight (Adjacency) matrix is obtained to calculate the GFT matrix, then the GFRT matrix.

### JTV Signal Generation

Joint Time-Vertex (JTV) signal is defined such that its rows are various pure sinusoidal whose frequencies are linearly spaced between $f_{\min} = 10$ Hz and $f_{\max}=50$ Hz, for each vertex. For example for the first vertex, $v_1$, its time series is defined as $\boldsymbol{x}_1[t] = \cos(2\pi (10) \frac{t}{T_s})$ where $T_s$ is the sampling period, and $t=0,\dots,T-1$ where $T$ is the length of the time signals.

### Error Definition

Results are dependent on the definition of the error, we have the following two options, for $\boldsymbol{E}\triangleq\boldsymbol{X}-\boldsymbol{X_{est}}$. The Fro. norm regeneration results closer to the original signal, but the optimal point is $\alpha=1$.

1. $\frac{1}{NT}{\lVert \boldsymbol{E} \rVert}_F$: Let $\boldsymbol{e}_i^\top$ be the $i^{\text{th}}$ row of the matrix $\boldsymbol{E}$, then MSE of $i^{\text{th}}$ signal can be calculated as

    $$\frac{1}{T} \boldsymbol{e}^{\top}\_i\boldsymbol{e}\_i$$

    Then, we can take mean over all vertices as $\frac{1}{NT}\sum_{i\in V}\boldsymbol{e}_i^\top\boldsymbol{e}_i$.

1. $\frac{1}{NT}{\lVert \boldsymbol{E} \rVert}_2$: The default norm in MATLAB is $2$-norm even for matrices, which corresponds the largest singular value, utilization of this norm generates very different results.

### Implementation Details

- [`dFRT.m`](./dFRT.m) file is utilized to generate the FRT matrix, $\boldsymbol{F}^{\alpha}$, and its inverse transform is calculated via the generated matrix $\boldsymbol{F}^{-\alpha}$
- Graph Fourier Transform (GFT) matrix, $\boldsymbol{F}_{\mathcal{G}}$, is generated based on the weight matrix of the aforementioned graph. Depending on the provided method selection, it is based solely on weight matrix, or the graph Laplacian. This step is obtained with eigen-decomposition of the requested method's matrix. Inverse of the matrix of eigenvectors is the forward transform, where the eigenvector matrix itself is the inverse transform.
- Graph Fractional Fourier Transform (GFRT) matrix,
    $$\boldsymbol{F}_{\mathcal{G}}^{\beta},$$

    calculated from the diagonalization (eigen-decomposition) of the GFT matrix. Diagonal matrix is taken to the power $\beta$ to obtain GFRT matrix. Finally, its inverse transform is from $\boldsymbol{F}_{\mathcal{G}}^{-\beta}$.
- At this stage, JFRT transform, $\text{JFT}^{\alpha,\beta}\left(\boldsymbol{X};\mathcal{G}\right)$, of given JTV signal $\boldsymbol{X}$, is obtained by

    $$\hat{\boldsymbol{X}} = \boldsymbol{F}_{\mathcal{G}}^{\beta}\boldsymbol{X}{(\boldsymbol{F}^{\alpha})}^\top,$$

    and the inverse transform is defined over

    $$\boldsymbol{X} = \boldsymbol{F}_{\mathcal{G}}^{-\beta}\hat{\boldsymbol{X}}{(\boldsymbol{F}^{-\alpha})}^\top.$$

- Filtering is implemented with seperate filters in GFRT domain and FRT domain, where $\boldsymbol{H}\_{\mathcal{G}}$ and $\boldsymbol{H}\_{T}$ are GFRT and FRT domain filters, respectively.

    $$\boldsymbol{X}_{\text{filtered}} =\boldsymbol{F}^{-\beta}\_{\mathcal{G}}\bigg(\boldsymbol{H}\_{\mathcal{G}}^{\beta}\underbrace{\left(\boldsymbol{F}\_{\mathcal{G}}^{\beta}\boldsymbol{X}{(\boldsymbol{F}^{\alpha})}^\top\right)}\_{\text{JFT}^{\alpha,\beta}(\boldsymbol{X};\mathcal{G})}\boldsymbol{H}\_{T}\bigg){(\boldsymbol{F}^{-\alpha})}^\top$$


