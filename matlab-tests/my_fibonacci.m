function Fn = my_fibonacci(n)
    if n == 0
        Fn = 0;
    elseif n == 1
        Fn = 1;
    else
        Fn = fibonacci(n-1)+fibonacci(n-2);
    end
end