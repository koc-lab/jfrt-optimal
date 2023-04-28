# Real World Optimal Filtering Task

## COVID19-USA Dataset

The current form of the `main.m` and `analyze_results.m` scripts are set to run the real-world denoising experiment on _Sea Surface Temperature_ dataset, to generate the results for _COVID19-USA_ dataset change the following lines in the `main.m` script:

```matlab
- dataset = "sea-surface-temperature.mat";
+ dataset = "covid19-usa.mat";

- max_time_count = 120;
+ max_time_count = 302;

- for noise_sigma = [0.10, 0.15, 0.20]
+ for noise_sigma = [0.010, 0.015, 0.020]

- HT = time_filter(size(X, 2), floor(0.15 * size(X, 2)));
+ HT = time_filter(size(X, 2), floor(0.25 * size(X, 2)));
```

and the following lines in `analyze_results.m`:

```matlab
-    for sigma = [0.10, 0.15, 0.20]
-        s = sprintf("sst-results-ht020/results_k%d_%.3f.mat", k, sigma);

+    for sigma = [0.010, 0.015, 0.020]
+        s = sprintf("covid19usa-results-N100/results_k%d_%.3f.mat", k, sigma);
```

## Acknowledgement

[Ben Tordoff](https://www.mathworks.com/matlabcentral/profile/authors/1297191)'s [`multiWaitbar`](https://www.mathworks.com/matlabcentral/fileexchange/26589-multiwaitbar) script has been utilized, which is copyrighted to the MathWorks, Inc.
