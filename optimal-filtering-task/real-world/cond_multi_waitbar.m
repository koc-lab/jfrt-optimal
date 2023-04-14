function cond_multi_waitbar(condition, string, value)
    if condition
        multiWaitbar( string, value );
    end
end
