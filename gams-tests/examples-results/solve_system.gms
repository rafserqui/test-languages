*================================================================
* Problem 3: Solve system of eqns
*================================================================

Variable x first independent variable
         y secnd independent variable
         z third independent variable
         dd objective function;

Equations eq1 first eqn in system  
          eq2 secnd eqn in system
          eq3 third eqn in system
          vf value function;

          eq1.. 2*x*y + y + z =e= 10;
          eq2.. 2*x - power(y,2) + 3*z =e= 0;
          eq3.. x + y + z =e= 3;
          vf.. dd =e= 10;

* Initial values
x.l = -0.5;
y.l = -5;
z.l = 7;

model sys1 /all/

* Options for exporting
File results / "D:\RESEARCH\test-languages\gams-tests\examples-results\systems.csv" /;
*.pc means "print control" options 4, 5, 6 and 8 create delimited files
* 5: Formatted output; non-numeric output is quoted and each item is delimited with commas. CSV style
results.pc=5; 
*.pw means "page width" Number of columns (characters) that may be placed on a single row of the page
results.pw=5000;
*.nd means "number of decimals"
results.nd = 4;

* Solve
solve sys1 using NLP minimizing dd;

display x.l, y.l, z.l 

put results "Optimal Values";
put / "Variable x";
put x.l;

put / "Variable y";
put y.l;

put / "Variable z";
put z.l;