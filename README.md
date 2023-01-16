# JFRT Experiments

After the feedback of the reviewers, the _Wiener Filtering in Joint Time-Vertex Fractional Fourier Transform Domains_ paper needed updates for the experiments. This repository will contain the source code, and will serve as a documentation for the updated experiments.

## Installation

This repository depends on the EPFL's _Graph Signal Processing Toolbox_ [`gspbox`](https://github.com/epfl-lts2/gspbox), which is also added as a `submodule`. If you already have a way to include `gspbox` to your path, then you can ignore this. However, if you want to download the code with its `gspbox` dependency, you need to use `--recursive` option while cloning, e.g.,

```sh
git clone --recursive https://github.com/koc-lab/jfrt-experiments.git
```

or

```sh
gh repo clone koc-lab/jfrt-experiments -- --recursive
```
