*================================================================
* Problem 1: Find zeros of f(x) = x^2+5x+1
*================================================================

Variable x independent variable
         z objective function ;

* Initial value
x.l = 0;

* A helpful scalar to find other solutions
scalar tol /5/;

Equations fx function f(x)
    obj dummy objective function to be used;

    fx.. power(x,2)+5*x+1=e=0;
    obj.. z=e=0;

model roots /all/
option nlp = conopt4

* Options for exporting
File results / "D:\RESEARCH\test-languages\gams-tests\examples-results\roots.csv" /;
*.pc means "print control" options 4, 5, 6 and 8 create delimited files
* 5: Formatted output; non-numeric output is quoted and each item is delimited with commas. CSV style
results.pc=5; 
*.pw means "page width" Number of columns (characters) that may be placed on a single row of the page
results.pw=5000;
*.nd means "number of decimals"
results.nd = 4;

* Solve
solve roots using NLP minimizing z;

* Display
display x.l;

* Each put is a row
Put results 'Roots of 2nd Degree Polynomial';
Put / "Root 1";
put x.l;

*============================================
*Export to CSV
*============================================
* This only finds one root, let's look for the second one
* Add new initial value
x.l = x.l - tol;

* New guess
solve roots using NLP minimizing z;
display x.l

Put results;
put / "Root 2";
put x.l

*================================================================
* Problem 2: Find zeros of g(x) = 5x^3 - 2x + 5
*================================================================
Variable x1 independent variable
        g dummy optimization;

Equations gx function g(x)
        v objective function;

    gx.. 5*power(x1,3) - 2*x1 + 5 =e= 0;
    v..  g =e= 10;

model rootscube /all/

solve rootscube using NLP minimizing g;
display x1.l 

* By inspection of the function, it only has one real root
Put / 'Roots of 3rd Degree Polynomial';
Put / "Root";
Put x1.l;