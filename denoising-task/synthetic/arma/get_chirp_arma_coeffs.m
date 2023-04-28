function [b, a] = get_chirp_arma_coeffs(G, mu, order, normalize)
    ar_order  = order;
    ma_order  = order;
    if order == 3
        ma_order = 2;
    end

    radius    = 0.99;
    lambda_cut = 1.5;
    step     = @(x,a) double(x>=a);  
    response = @(x) step(x, G.lmax/2 - lambda_cut); 
    [b, a, rARMA, design_err] = agsp_design_ARMA(mu, response, ma_order, ...
                                                 ar_order, radius);
    if normalize
        [h, w] = freqz(b, a);
        hn = h / max(abs(h));
        [b, a] = invfreqz(hn, w, length(b), length(a));
    end

    if order == 3
        b = b(:).';
        b = [b, 0];
    end
end
