function cond_multi_waitbar(condition, string, value)
    if condition
        multiWaitbar( string, value );
    elseif value == 'Close'
        fprintf("%s, Done.\n", string);
    else
        fprintf("%s, %.2f%%\n", string, value * 100);
    end
end
