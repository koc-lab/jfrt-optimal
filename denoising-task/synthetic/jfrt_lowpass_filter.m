function X_filtered = jfrt_lowpass_filter(X, jfrt_pair, ...
    graph_filter_count, time_sampling_freq, time_cutoff_freq)

X_transform = jfrt_pair("GFRT") * X * jfrt_pair("FRT_T");
X_hat_filtered = combined_lowpass_filter(X_transform, ...
                                         graph_filter_count, ...
                                         time_sampling_freq, time_cutoff_freq);
X_filtered = real(jfrt_pair("IGFRT") * X_hat_filtered * jfrt_pair("IFRT_T"));
end

function filtered = combined_lowpass_filter(X, count, sampling_freq, cutoff_freq)
H_G = graph_filter(size(X, 1), count);
H_T = time_filter(size(X, 2), sampling_freq, cutoff_freq);
filtered = H_G * X * H_T;
end

function H = time_filter(length, sampling_freq, cutoff_freq)
if 2 * cutoff_freq > sampling_freq
    warning("Cutoff frequency larger than half sampling frequency, no filtering.");
end
   
h = zeros(length, 1);
n = min(length, floor(length * cutoff_freq / sampling_freq));

h(1:n) = 1;
h(end - n + 1:end) = 1;

H = diag(h);
end

function H = graph_filter(N, count)
if count >= N
    h = zeros(N, 1);
else
    h = [ones(N - count, 1); zeros(count, 1)];
end

H = diag(h);
end
