function [b, a] = get_arma_coeff_k10(G, mu, order)
    ar_order  = order;
    ma_order  = order;
    if order > 1
      ma_order = ma_order - 1;
    end

    radius    = 0.99;
    if order == 1
        lambda_cut = 1.96;
    elseif order == 2
        lambda_cut = 1.94;
    elseif order == 3
        lambda_cut = 1.95;
    else
        lambda_cut = 2;
    end

    fprintf("G.lmax = %f, lambda_cut = %f\n", G.lmax, lambda_cut);
    step     = @(x,a) double(x>=a);
    response = @(x) step(x, G.lmax/2 - lambda_cut);
    [b, a, rARMA, design_err] = agsp_design_ARMA(mu, response, ma_order, ...
                                                 ar_order, radius);
    [h, w] = freqz(b, a);
    hn = h / max(abs(h));
    warning('off', 'all');
    [b, a] = invfreqz(hn, w, length(b), length(a));

    a = a(:).';
    if order > 1
        b = b(:).';
        b = [b, 0];
    end
end
