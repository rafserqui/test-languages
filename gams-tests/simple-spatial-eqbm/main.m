clear
close all
clc

%================================================
% Initialize Log
%================================================
fprintf('Today is %s \n',datetime('now'))

tic
% For replication, set random number stream (if TFPs are randomly generated)
s = RandStream('mt19937ar','Seed',1);
RandStream.setGlobalStream(s);

% Figures settings (can be commented out)
set(0,'defaulttextinterpreter','factory')
set(0,'defaultAxesFontName','Palatino LinoType')
set(0,'DefaultAxesTitleFontSizeMultiplier',1.4)

%================================================
% Parameters
%================================================
alph = 0.1;
bett = -0.33333;
sigm = 5;
g1 = 1 - alph*(sigm - 1) - bett*sigm;
g2 = 1 + alph*sigm + (sigm - 1)*bett;
sigt = (sigm - 1)./(2*sigm - 1);

disp('Checking conditions for parameters')

if g1 > 0
    disp('Eqbm is regular')
elseif g1 < 0
    disp('Eqbm is not point-wise locally stable')
end

if (g2/g1) > -1 && (g2/g1) <= 1
    disp('Eqbm is unique and can be computed through iteration.')
else
    disp('Conditions for Thm2 are not satisfied.')
end

%================================================
% Geography
%================================================
% Number of locations
n = 40;
locs = n^2;

xcoord = (1:n)';
ycoord = (1:n)';

[X,Y] = meshgrid(xcoord,ycoord);

% Exogenous TFPs and amenities
shocks = normrnd(0,0.1,locs,2);

% TFPs
A = (sin(-X.*(pi./250) - Y.*(pi./200))+1).*exp(reshape(shocks(:,1),n,n));
A = reshape(A,locs,1);
A = A./geomean(A);

% Amenities
u = (sin(X.*(pi./250) + Y.*(pi./200))+1).*exp(reshape(shocks(:,2),n,n));
u = reshape(u,locs,1);
u = u./geomean(u);

% Transport matrix
T = toeplitz(1:locs);
T = 1 + T./locs - 1./locs;

%================================================
% SOLVE FOR EQUILIBRIUM
%================================================
tol_epsi = 1e-18;              % Convergence criterion    
maxit = 1e7;                   % Max number of iterations

% Guess initial distribution of population equally distributed
Lb = 46.66*1e6;
L0 = ones(locs,1).*(Lb./locs);

params = [alph,bett,sigm,g1,g2,sigt];

[Li,wi,lambda,converged] = solve_eqbm(params,L0,A,u,T,tol_epsi,maxit,locs,Lb);

if converged == 1
    disp('Solution to the integral eqn found!')
else
    disp('No solution found')
end

% Welfare from system eigenvalue
W = lambda.^(1./(1-sigm));

timeelapsed = toc;
disp(['Pop constraint satisfied up to ',num2str(abs(Lb-sum(Li)))])
disp(['Time for solving in MATLAB ',num2str(timeelapsed)])

%================================================
% SOLVE FOR EQUILIBRIUM IN GAMS
%================================================
disp('Defining sets and parameters for GAMS...')

% Define sets
Is.name = 'i';
Is.val = (1:locs)';
Is.type = 'set';

% Define parameters of geography
transp.name = 'T';
transp.type = 'parameter';
transp.val  = T;
transp.form = 'full';
transp.dim  = 2;              % B/c it's a table
tfp.name = 'A';
tfp.type = 'parameter';
tfp.val  = A;
tfp.form = 'full';
tfp.dim  = 1;                 % B/c it's a vector
amenities.name = 'u';
amenities.type = 'parameter';
amenities.val  = u;
amenities.form = 'full';
amenities.dim  = 1;           % B/c it's a vector

% Define deep parameters and guesses
elast.name = 'sigm';
elast.type = 'parameter';
elast.val  = sigm;
elast.form = 'full';
elast.dim  = 0;
tfpa.name = 'alph';
tfpa.type = 'parameter';
tfpa.val  = alph;
tfpa.form = 'full';
tfpa.dim  = 0;
ubet.name = 'bett';
ubet.type = 'parameter';
ubet.val  = bett;
ubet.form = 'full';
ubet.dim  = 0;
pop.name = 'Lb';
pop.type = 'parameter';
pop.val  = Lb;
pop.form = 'full';
pop.dim  = 0;

true_solution = 0;

if true_solution == 1
    disp('Feeding true solution to GAMS')
    inL.name = 'L0';
    inL.type = 'parameter';
    inL.val  = Li;
    inL.form = 'full';
    inL.dim  = 1;
    inW.name = 'w0';
    inW.type = 'parameter';
    inW.val  = wi;
    inW.form = 'full';
    inW.dim  = 1;
else
    disp('Feeding initial guess to GAMS')
    inL.name = 'L0';
    inL.type = 'parameter';
    inL.val  = L0;
    inL.form = 'full';
    inL.dim  = 1;
    inW.name = 'w0';
    inW.type = 'parameter';
    inW.val  = mean(wi).*ones(locs,1);
    inW.form = 'full';
    inW.dim  = 1;
end

% Write values of parameters in GDX file
wgdx('spatial_parameters',Is,transp,tfp,amenities,elast,tfpa,ubet,pop,inL,inW)

% Run GAMS code
disp('======================================================================')
disp('------------------------- GAMS COMPILATION ---------------------------')
disp('======================================================================')
system(['gams spatial_parametric lo=3 gdx=spatial_results'])

% Read variables from GAMS
resL.name = 'L';
resL.form = 'full';
r1 = rgdx('spatial_results',resL);
Lg = r1.val;

resw.name = 'w';
resw.form = 'full';
r2 = rgdx('spatial_results',resw);
wg = r2.val;

resUb.name = 'Ub';
resUb.form = 'full';
r3 = rgdx('spatial_results',resUb);
Ub = r3.val;

% Rescale wages
wg = wg./(min(wg)./min(wi));

disp('Comparing Solutions')

disp(['Difference in welfare ',num2str(abs(W-Ub))])
disp(['Difference in labor ',num2str(norm(Lg-Li))])
disp(['Difference in wages ',num2str(norm(wg-wi))])
disp(['Pop constraint satisfied up to ',num2str(abs(Lb-sum(Lg)))])

figure('units','normalized','outerposition',[0.05 0.05 0.65 0.85])
subplot(2,2,1)
imagesc(reshape(Li./Lb,n,n))
colorbar;
title('Labor (True Solution)')
subplot(2,2,2)
imagesc(reshape(wi,n,n))
colorbar;
title('Wages (True Solution)')
subplot(2,2,3)
imagesc(reshape(Lg./Lb,n,n))
colorbar;
title('Labor (GAMS Solution)')
subplot(2,2,4)
imagesc(reshape(wg,n,n))
colorbar;
title('Wages (GAMS Solution)')
print('gams_matlab_eqbm','-dpng','-r0');
