# JFRT Experiments

After the feedback of the reviewers, the _Wiener Filtering in Joint Time-Vertex Fractional Fourier Transform Domains_ paper needed updates for the experiments. This repository will contain the source code, and will serve as a documentation for the updated experiments.

## Dependencies

1. EPFL's _Graph Signal Processing Toolbox_ (`gspbox`): see [GitHub](https://github.com/epfl-lts2/gspbox) and [documentation](https://epfl-lts2.github.io/gspbox-html/) pages.
    - The project assumes the `gspbox` directory is present in the root of the project, and compiled according to the directives presented in the [documentation](https://epfl-lts2.github.io/gspbox-html/download.html).
    - If you already have a way to include `gspbox` to your path, then you can ignore this. However, if you want to download the code with its `gspbox` dependency, you need to use `--recursive` option while cloning, e.g.,

        ```sh
        git clone --recursive https://github.com/koc-lab/jfrt-experiments.git
        ```

        or with [GitHub CLI](https://cli.github.com/),

        ```sh
        gh repo clone koc-lab/jfrt-experiments -- --recursive
        ```

2. `CVX`, which is a _MATLAB Software for Disciplined Convex Programming_: see [GitHub](https://github.com/cvxr/CVX) and [documentation](http://cvxr.com/cvx/) pages.
    - The `CVX` library is needed by the `graph-arma` component of the codebase, which is an implementation of the _Autoregressive Moving Average Graph Filtering_ paper (published in: IEEE _Transactions on Signal Processing_ Volume: 65, Issue: 2, 15 January 2017), and it is based on the provided source code by Andreas Loukas on his [blog](https://andreasloukas.blog/code/). `CVX` library needs to be installed in order to design ARMA graph filters, so you do not need it if you are not going to use `graph-arma` codes.
    - The best way to obtain CVX is to visit the [download page](http://cvxr.com/cvx/download/), which provides pre-built archives containing standard and professional versions of CVX tailored for specific operating systems. That is why `CVX` is not added as a submodule like `gspbox`. They advise not to manually add it to path and use a setup script, hence it does not matter where you place the library other than some given restrictions (see [documentation](http://web.cvxr.com/cvx/doc/install.html)).

## Installation

1. Clone the repository
   - If you want the `gspbox` as submodule, clone recursively (see [Dependencies](#dependencies) section).
2. Install `gspbox` dependency, by entering `gspbox` directory in MATLAB prompt, and running the following command (see [documentation](https://epfl-lts2.github.io/gspbox-html/download.html) for further details):

    ```matlab
    gsp_start; gsp_make; gsp_install;
    ```

3. Install `CVX` dependency, by installing the pre-built archive for your operating system and extracting it. Then, by entering `cvx` directory in MATLAB prompt, run the following command, and _do not try to manually add the directory to path_ (see [documentation](http://web.cvxr.com/cvx/doc/install.html) for further details):

    ```matlab
    cvx_setup
    ```
