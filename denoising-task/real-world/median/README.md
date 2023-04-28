# Real-World Denoising Task - Median Filter

The current form of the `main.m` script is set to run the real-world denoising experiment on _Sea Surface Temperature_ dataset, to generate the results for _COVID19-USA_ dataset change the following lines in the `main.m` script:

```matlab
- dataset = "sea-surface-temperature.mat";
+ dataset = "covid19-usa.mat";

- max_time_count = 120;
+ max_time_count = 302;

- noise_sigmas = [0.10, 0.15, 0.20];
+ noise_sigmas = [0.010, 0.015, 0.020];
```
