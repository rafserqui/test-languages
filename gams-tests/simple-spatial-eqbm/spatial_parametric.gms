Sets
    i "locations";

Alias (i,j);

Parameters T(i,j) "matrix of transport costs"
           A(i) "productivities"
           u(i) "amenities"
           sigm  "elasticity of substitution"
           alph  "spillovers in TFP"
           bett  "spillovers in amenities"
           Lb    "total population"
           L0(i) "initial guess for labor"
           w0(i) "initial guess for wages";

$gdxin spatial_parameters.gdx
$load i T A u sigm alph bett Lb L0 w0
$gdxin

Variables
    L(i) "population in location"
    w(i) "wages in location"
    Ub   "welfare equalization"
    z    "dummy maximizer";

Positive Variables L, w, Ub;

* Model with spillovers
Equations
    dumm            define objective function
    welfare         define welfare equalization condition
    indirectutil    define indirect utility function
    population      define labor market clearing
    mktclearing     define market clearing condition;

dumm .. z =e= 1;

* Labor market clearing condition
population.. Lb =e= sum(i, L(i));

* Market clearing condition
mktclearing(i).. (L(i)**(1-alph*(sigm-1)))*(w(i)**(sigm)) =e= ((1/Ub)**(sigm-1))*sum(j, (((A(i)*u(j))/T(i,j))**(sigm-1))*(1/L(j)**(-bett*(sigm-1)-1))*w(j)**(sigm));

* Indirect utility
indirectutil(i).. (L(i)**(bett*(1-sigm)))*((1/w(i))**(sigm-1)) =e= ((1/Ub)**(sigm-1))*sum(j, (((A(j)*u(i))/(T(j,i)*w(j)))**(sigm-1))*(L(j)**(alph*(sigm-1))));

* Welfare equalization condition
welfare.. Ub =e= (1/Lb)*sum(i, (w(i)*u(i)*(L(i)**(1+bett)))/(1/(sum(j, ((A(j)*(L(j)**(alph)))/(T(j,i)*w(j)))**(sigm-1)))**(1/(sigm-1))));

* Initial guesses
L.l(i) = L0(i);
w.l(i) = w0(i);
Ub.l = 1;

* Upper bounds
L.up(i) = Lb;
w.up(i) = 1e11;
Ub.up   = 1e11;

* Lower bounds
L.lo(i) = 1e-6;
w.lo(i) = 1e-6;

*Model spatial /all/ ;

* Population constraint is redundant since it is substituted into welfare equalization
Model spatial /mktclearing indirectutil welfare dumm/

option nlp = conopt4;
option resLim = 3500;

Solve spatial using nlp maximizing z ;

display L.l, w.l, Ub.l;

execute_unload 'spatial_results', L.l, w.l, Ub;