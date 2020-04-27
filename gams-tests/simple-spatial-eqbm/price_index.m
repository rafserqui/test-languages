function P = price_index(sigm,alph,A,wi,Li,T,NN)
    % Compute price index based on eqn (4)

    Ps = zeros(NN,NN);
    % Compute inner part of integral
    for n = 1:NN
        for s = 1:NN
            Ps(s,n) = (T(s,n).^(1-sigm)).*(A(s).^(sigm-1)).*(wi(s).^(1-sigm)).*(Li(s).^(alph.*(sigm-1)));
        end
    end

    P = sum(Ps);
    P = P';
    P = P.^(1./(1-sigm));
end