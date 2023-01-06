# Autoregressive Moving Average Graph Filtering

This is an implementation of the _Autoregressive Moving Average Graph Filtering_ paper (published in: IEEE _Transactions on Signal Processing_ Volume: 65, Issue: 2, 15 January 2017), and it is based on the provided source code by Andreas Loukas on his [blog](https://andreasloukas.blog/code/).

## Manuscript Links

- [IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/7581108)
- [arXiv](https://arxiv.org/abs/1602.04436)

## Installation

This repository depends on the EPFL's _Graph Signal Processing Toolbox_ [`gspbox`](https://github.com/epfl-lts2/gspbox), which is also added as a `submodule`. If you already have a way to include `gspbox` to your path, then you can ignore this. However, if you want to download the code with its `gspbox` dependency, you need to use `--recursive` option while cloning, e.g.,

```sh
git clone --recursive https://github.com/koc-lab/graph-arma.git
```

or

```sh
gh repo clone koc-lab/graph-arma -- --recursive
```
