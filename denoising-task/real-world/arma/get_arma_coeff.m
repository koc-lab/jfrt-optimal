function [b, a] = get_arma_coeff(G, mu, order, normalize)
    ar_order  = order;
    ma_order  = order;
    if (normalize && order == 3) || (~normalize && order == 4)
      ma_order = ma_order - 1;
    end

    radius    = 0.99;
    % lambda_cut = 1.4;
    lambda_cut = floor(G.lmax * 10) / 10;
    fprintf("G.lmax = %f, lambda_cut = %f\n", G.lmax, lambda_cut);
    step     = @(x,a) double(x>=a);
    response = @(x) step(x, G.lmax/2 - lambda_cut);
    [b, a, rARMA, design_err] = agsp_design_ARMA(mu, response, ma_order, ...
                                                 ar_order, radius);
    if normalize
        [h, w] = freqz(b, a);
        hn = h / max(abs(h));
        [b, a] = invfreqz(hn, w, length(b), length(a));
    end

    if (normalize && order == 3) || (~normalize && order == 4)
        b = b(:).';
        b = [b, 0];
    end
end
