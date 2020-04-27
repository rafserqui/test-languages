function [Li,wi,lambda,converged] = solve_eqbm(params,x0,A,u,T,tol_epsi,maxit,NN,L)
    
    
    % Initial difference
    difference = 1e10;             
    it = 0;

    % Parameters
    alph = params(1);
    bett = params(2);
    sigm = params(3);
    g1 = params(4);
    g2 = params(5);
    sigt = params(6);

    % Initial guess
    Li0 = x0(:,1);

    % Kernel function
    K = zeros(NN,NN);
    for n = 1:NN 
        for s = 1:NN
            K(s,n) = (u(n).^((1-sigt).*(sigm - 1))).*(A(n).^(sigt.*(sigm-1))).*(T(s,n).^(1-sigm)).*(A(s).^((1-sigt).*(sigm - 1))).*(u(s).^((sigm - 1).*sigt));
        end
    end

    % Solve eqbm for ftilde = f lambda^(1./((g2./g1) - 1)) and f = L^(g1)
    f0 = Li0.^(g1);
    
    while (difference > tol_epsi) && (it < maxit)
        % Compute right-hand side of integral eqn
        Kf = zeros(NN,NN);
        for n = 1:NN
            for s = 1:NN 
                Kf(s,n) = K(s,n).*(f0(s).^(g2./g1));
            end
        end

        % Compute left-hand (new guess)
        f1 = sum(Kf);
        f1 = f1';

        % Compute difference
        difference = norm(f1-f0);

        % Update
        f0 = f1;
        it = it+1;

        % Inform every 10 iterations
        if (it > 1) && (mod(it,20) == 0)
            disp(['Iteration: ',num2str(it)])
            disp(['Max diff: ',num2str(difference)])
        end

        % Dummy for convergence
        if (it == maxit) && (difference > tol_epsi)
            converged = 0;
        elseif (it < maxit) && (difference < tol_epsi)
            converged = 1;
        else
            converged = 2;
        end
    end % end while

    fprintf('Number of iterations: %3.0f \n',it)
    f = f1;

    % Compute eigenvalue of the  system
    intf = sum(f.^(1./(sigt.*g1)));
    lambda = (L./intf).^((g1-g2).*sigt);

    % Determine distribution of population
    Li = (f.^(1./(sigt.*g1))).*(lambda.^(1./(sigt.*(g1-g2))));

    % Determine wages up to scale (actually => phi.^(1./(1-2sigm)))wi
    wi = ((Li.^(1 + alph.*(1-sigm) + (sigm - 1).*bett)).*(A.^(1-sigm)).*(u.^(sigm-1))).^(1./(1-2.*sigm));
end