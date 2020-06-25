* This file contains a model of production with intermediate inputs used in variable proportions, as described in Chapter 10 of 
* Gilbert and Tower: Introduction to Numerical Simulation for Trade Theory and Policy.
* Contact: jgilbert@usu.edu or tower@econ.duke.edu.

* Define the indexes for the problem

SET I Goods /1,2/;
SET J Factors /K,L,N/;
ALIAS (J, JJ);
ALIAS (I, II); 
ALIAS (I, III);  

* Create names for parameters

PARAMETERS
GAMMAQ(I) 	Shift parameters in production
DELTAQ(I) 	Share parameters in production
RHOQ(I) 	Elasticity parameters in production
GAMMAI(I) 	Shift parameters in production
DELTAI(II,I) 	Share parameters in production
RHOI(I) 	Elasticity parameters in production
GAMMAV(I) 	Shift parameters in production
DELTAV(J,I) 	Share parameters in production
RHOV(I) 	Elasticity parameters in production
P(I) 		Output prices
FBAR(J) 	Endowments
QO(I) 		Initial output levels
VO(I)	        Initial value added levels
MO(I)		Initial aggregrate intermediate use levels
RO(J) 		Initial factor prices
FO(J,I) 	Initial factor use levels
GDPO 		Initial gross domestic product;

* Assign values to the parameters

P(I)=1;
RO(J)=1;
QO(I)=150;
FO('L','1')=20;
FO('L','2')=80;

TABLE INTO(II,I) 	Initial intermediate use levels
	1	2	
1	40	10	
2	10	40 ;

FO('K','1')=(QO('1')*P('1')-FO('L','1')*RO('L')-SUM(II, INTO(II,'1')*P(II)))/RO('K');
FO('N','2')=(QO('2')*P('2')-FO('L','2')*RO('L')-SUM(II, INTO(II,'2')*P(II)))/RO('N');
FBAR(J)=SUM(I, FO(J,I));
VO(I)=SUM(J$FO(J,I), FO(J,I));
MO(I)=SUM(II,INTO(II,I));
GDPO=SUM(I, P(I)*(QO(I)-MO(I)));
RHOQ(I)=-10;
RHOV(I)=0.1;
RHOI(I)=-10;
DELTAQ(I)=(1/VO(I)**(RHOQ(I)-1))/(1/VO(I)**(RHOQ(I)-1)+1/MO(I)**(RHOQ(I)-1));
DELTAV(J,I)$FO(J,I)=(RO(J)/FO(J,I)**(RHOV(I)-1))/(SUM(JJ$FO(JJ,I), RO(JJ)/FO(JJ,I)**(RHOV(I)-1)));
DELTAI(II,I)$INTO(II,I)=(P(II)/INTO(II,I)**(RHOI(I)-1))/(SUM(III$INTO(III,I), P(III)/INTO(III,I)**(RHOI(I)-1)));
GAMMAQ(I)=QO(I)/(DELTAQ(I)*VO(I)**RHOQ(I)+(1-DELTAQ(I))*MO(I)**RHOQ(I))**(1/RHOQ(I));
GAMMAI(I)=MO(I)/(SUM(II$INTO(II,I), DELTAI(II,I)*INTO(II,I)**RHOI(I)))**(1/RHOI(I));
GAMMAV(I)=VO(I)/(SUM(J$FO(J,I), DELTAV(J,I)*FO(J,I)**RHOV(I)))**(1/RHOV(I));

* Create names for variables

VARIABLES
Q(I) 		Output levels
V(I)		Value added levels
M(I)		Aggregate intermediate use levels
INT(II,I)	Intermediate use levels
R(J) 		Factor prices
F(J,I) 		Factor use levels
GDP 		Gross domestic product;

* Assign initial values to variables, and set lower bounds

Q.L(I)=QO(I);
R.L(J)=RO(J);
V.L(I)=VO(I);
M.L(I)=MO(I);
INT.L(II,I)=INTO(II,I);
F.L(J,I)=FO(J,I);
GDP.L=GDPO;
Q.LO(I)=0;
R.LO(J)=0;
F.LO(J,I)=0;
V.LO(I)=0;
M.LO(I)=0;
INT.LO(II,I)=0;

* Create names for equations

EQUATIONS
PRODUCTION(I) 	Production functions
VALUE(I)	Value added
INTERMED(I)	Intermediate
RESOURCE(J) 	Resource constraints
FDEMAND(J,I) 	Factor demand functions
IDEMAND(II,I)	Intermediate demands
INCOME 		Gross domestic product;

* Assign the expressions to the equation names

PRODUCTION(I)..Q(I)=E=GAMMAQ(I)*(DELTAQ(I)*V(I)**RHOQ(I)+(1-DELTAQ(I))*M(I)**RHOQ(I))**(1/RHOQ(I));
INTERMED(I)..M(I)=E=GAMMAI(I)*(SUM(II$INTO(II,I), DELTAI(II,I)*INT(II,I)**RHOI(I)))**(1/RHOI(I));
VALUE(I)..V(I)=E=GAMMAV(I)*SUM(J$FO(J,I), DELTAV(J,I)*F(J,I)**RHOV(I))**(1/RHOV(I));
RESOURCE(J)..FBAR(J)=E=SUM(I, F(J,I));
FDEMAND(J,I)$FO(J,I)..R(J)=E=P(I)*Q(I)**(1-RHOQ(I))*V(I)**(RHOQ(I)-RHOV(I))*(GAMMAQ(I)**RHOQ(I))*(GAMMAV(I)**RHOV(I))*DELTAQ(I)*DELTAV(J,I)*F(J,I)**(RHOV(I)-1);
IDEMAND(II,I)$INTO(II,I)..P(II)=E=P(I)*Q(I)**(1-RHOQ(I))*M(I)**(RHOQ(I)-RHOI(I))*(GAMMAQ(I)**RHOQ(I))*(GAMMAI(I)**RHOI(I))*(1-DELTAQ(I))*DELTAI(II,I)*INT(II,I)**(RHOI(I)-1);
INCOME..GDP=E=SUM(I, P(I)*(Q(I)-M(I)));

* Define the equations that make the model, and solve

MODEL SF /ALL/;
SOLVE SF USING NLP MAXIMIZING GDP;