** Model Version November 25th, 2015
** Jevgenijs Steinbuks and Yongyang Cai
** 1 Region (World)
** Perfect Foresight over 400 Years
** 50 Forest Vintages with Replanting
** AIDADS Utility Function
** Linear and CES Production Functions
** Population, Exponential TFP Growth, Linear Yield Growth
** 7 Sectors
** Terminal Conditions
** Base Year 2004

* Define sets

SETS

t time periods /1*81/
tSteady(t) periods with steady exogenous paths
t0(t) First period
tT(t)  Last period
not0(t) Any but first period
notT(t) Any but last period
m(t) Any but first or last period
v forest vintages /1*10/
v0(v) First vintage
vV(v) Oldest vintage
notV(v) no Oldest vintage;

parameter Nsteady the start period with steady exogenous paths /40/;

tSteady(t) = yes$(ord(t)>Nsteady);
t0(t) = yes$(ord(t) EQ 1);
tT(t)  = yes$(ord(t) EQ card(t));
not0(t) = yes$(ord(t) GT 1);
notT(t) = yes$(ord(t) LT card(t));
m(t) = not (t0(t) + tT(t));
v0(v) = yes$(ord(v) EQ 1);
vV(v)  = yes$(ord(v) EQ card(v));
notV(v)  = yes$(ord(v) LT card(v));
alias(t,t1);

* Parameters

SCALARS

deltat number of years per period / 5 /

* Population

POP0  Population in time 0 in Billion People | \Pi_0  /6.39/
POPT Population in time T in Billion People | \Pi_{T} /10.1/
POPGR1 Logistic Population Growth Rate | \pi /0.042/

* Endowments

** Land Endowment

TLAND0 Total Gross Land in GHa | \overline{L} /8.559/
ALAND0 Area of Agricultural Land in Period 1 in GHa | L^{A}_{0} /1.533/
LLAND0 Area of Pasture Land in Period 1 in GHa | L^{P}_{0} /2.729/
NLAND0 Area of Natural Land in Period 1 in GHa | L_{0}^{N} /2.47/
PLAND0  Amount of Protected Land in Period in GHa | L_{0}^{R}  /0.207/
SHAREN Natural Land Conversion Cost Share | xi_{0}^{n} /0.6/
CLGAMMA Natural Land Conversion Cost Function Parameter | xi_{1}^{n} /105/

** Fossil Fuels Endowment

TFOSSIL0 Oil & Gas Reserves in 2004 in Ttoe | X^F /0.343/
OILGR Linear growth in Oil & Gas Reserves | DeltaX^F'D /0.008/

** Other Primary Factors

OTHER0 Endowment of other PF in time 0 in USD Trillion | y^{o}_{0} /3.16/
LABSHARE Contribution of Labor to Other PF /0.39/
OTHERGR Growth of non TFP Factors /0.0035/

* Production

** Agrichemical Sector

FERTILC Non-Energy Fertilizer costs in USD'1000 per ton | c^{o'n}/0.137/
FERTIL0 Fertilizers' Consumption at time 0 in Gton | x_{0}^{n} /0.937/
FERTPROD Fertilizer's Conversion rate in ton per toe | theta_^{n} /1.071/
SHAREFE Non Land Fertilizers share | c^{o'n} /2.08/

** Agricultural Sector

YIELD0 Crop Technology Index in time 0 | theta_{0}^{c}  /13.89/
* YIELD0 Ag. Yield in tons per Ha in time 0 | theta_{0}^{c}  /4.89/
YIELDTHH Ag. Yield in tons in time T - RCP 2.6 and good techn. progress
YIELDTHL Ag. Yield in tons in time T - RCP 8.5 and good techn. progress
YIELDTLH Ag. Yield in tons in time T - RCP 2.6 and bad techn. progress
YIELDTLL Ag. Yield in tons in time T - RCP 8.5 and bad techn. progress
YIELDGR Logistic Ag. Yield Growth Rate | kappa_{c} /0.025/
SHAREA Non Land Crop Production share | c^{o'c} /0.016/
SHAREM Non Land Biofuels Feedstocks Production share | c^{o'm} /0.022/
FTSIGMA Elasticity of Substitution between Land and Fertilizers / 1.14 /
FTALPHA Share of Commercial Land in CES function | alpha^{c} /0.55/
FTRHO  CES Transformation Parameter for Land and Fertilizers | rho^{c}
YIELDM0 Cell. Feedstocks Yield in tons per Ha in time 0 | theta_{0}^{m} /14.2/


* Livestock Sector

LSIGMA Elasticity of Substitution between Pasture Land and Feed /0.75/
LRHO   CES Transformation Parameter for Pasture Land and Feed  | rho^{l}
LALPHA Share of Pasture Land in CES function  | alpha^{l} /0.35/
LPROD0 Technology of Livestock Production | gamma_{l} /0.69/
SHAREL Non Land Livestock Farming Share | c^{o'l} /0.0055/
LADJ Adjustment Costs of Pasture Land Conversion  xi_{1}^{P} /170/

** Food Processing Sector

FDPRODGR Food Technology Index Growth Rate Per Annum | kappa_{f} / 0.0225 /
FDPROD0 Food Technology Index in time 0 | theta^{f}_{0} /1.5/
SHAREF Non Land Share in Crops Processing | c^{o'f} /0.015/
LPROD1 Technology of Livestock Processing theta^{l_2}_{0} /1.7/
LPRODGR Processed Livestock Technology Growth p.a.  kappa_{l} / 0.0025 /
SHAREFL Non Land Share in Livestock Processing | c^{o'y} /0.0068/

** Fossil Fuel Extraction and Refining Sector

FOSPROD0 Amount of liquid fuels per toe of oil | theta^p /0.5/
SHAREE Non-resource share of oil in petroleum extraction & refining | c^o'p /0.0157/
FOSADJ Adjustment costs of oil & gas extraction and refining | xi_{1}^{p}  /2000/

** Biofuels Sector

BIOF0 Biofuels Consumption in Period 1 in GToe | {for init. guess only} /0.04095/
BIOFPROD Biofuels' Conversion Rate per ton of Ag. Product | theta^{b} /0.283/
SHAREB Non Land Biofuels' Conversion Cost Share | c^{o'b1} /0.00025/
BMSIGMA Elasticity of Substitution between Fixed Factor and Cellulosic Feedstocks Crops /0.4/
BMRHO CES Transformation Parameter for Fixed Factor and Cellulosic Feedstocks Crops
BMALPHA Share of Cellulosic Feedstocks Crops in CES Function /0.6/
FIXEDFGR Technological Progress affecting Fixed Factor  /0.05/
SHAREBM Non Land 2G Biofuels' Conversion Cost Share | c^{o'b2} /0.00033/
BIOFPRODM 2nd Gen. Biofuels' Conversion Rate in toe per ton of feedstock / 0.467 /
FIXED Technology Fixed Factor in 2nd Gen. Biofuels  /0.005/

** Liquid Fuels Sector

BFSIGMA Elasticity of Substitution between Fossil Fuels and Biofuels | / 2 /
BFRHO CES Transformation Parameter for Fossil Fuels and Biofuels | rho_{e}
BFALPHA Share of Biofuels in CES Function | alpha_{e} / 0.09 /
BFGAMMA Energy Technology Index at time 0 | theta^{e}_{0} / 1.195 /
ENEFFGR Energy Efficiency Growth Rate per Annum | kappa_{e} / 0.0225 /

** Forestry Sector

TSHAREFO Total Forest Non-Land Cost Share | c^{0'w} /0.0021/
FOPRODNL Productivity of Other Factors in Forestry | theta^{w'o} /2.69/
SHARERP Forest Regeneration Cost Share | c^{p} /0.0001/
FORYA Forest Vintage Yield Parameter a
FORYB Forest Vintage Yield Parameter b /76.5/
HARADJ Adjustment Costs of Forest Conversion Parameter | xi^{H} /80/
PENCUTALL penalty for cutting all trees in one vintage / 0.004 /
CARBON Forest Carbon per Ha /340/
SHAREFN Forest Land Conversion to Natural Land Cost Share | xi_{0}^{C'N} /0.8/
FNADMCOST Adjustment Cost of Restoring Land Parameter | xi_{1}^{C'N} /400/

** Timber Processing Sector

TPRODGR Timber Processing Technology Growth Rate Per Annum | kappa_{s} / 0.0225 /
TPROD0 Timber Processing Technology Index in time 0 | theta^{s}_{0} /1.52/
SHARET Non-Land Timber Processing Cost Share | c^{o'y_w} / 0.0224/

** Recreation Sector

SHAREP Non Land Cost Share of Producting Recreation Services | c^{o'r} /0.0296/
SHARECP Non Land Administrative Cost Share of Protecting Land xi_{0}^{R} /4.5/
RECADMCOST1 Adjustment Cost of Protecting Land Parameter 1 | xi_{1}^{R} /400/
RECALPHA Share of Cropland in Ecosystem services |alpha^{A'r} /0.02/
RECALPHA1 Share of Pasture Land in Ecosystem Services |alpha^{P'r} /0.14/
RECALPHA2 Share of Commercial Forest Land in Ecosystem Services |alpha^{C'r} /0.26/
RECALPHA3 Share of Natural & Protected Land in Ecosystem Services
RECSIGMA Elasticity of Substitution between Ecosystem Services | sigma_{r} /1.1/
RECPLANDP Productivity of Protected Land Relative to Natural Land | theta^{R} /10/
RECRHO CES Parameter for Ecosystem Services | rho_{r}
RECGAMMA CES Parameter for production of ecosystem services | theta^{r} / 0.71 /

** Other Goods and Services

OPROD0 Conversion Rate to other G&S in time 0 | theta^{o}_{0} /2.0433/
TFPGR TFP Growth Rate Per Annum | kappa_{o} / 0.0225 /

* Welfare Parameters

ALPHAF Scale Parameter 1 of Food Products in Utility Function /0.158/
ALPHAL Scale Parameter 1 of Livestock Products in Utility Function  /0.0345/
ALPHAE Scale Parameter 1 of Energy Services in Utility Function | alpha_{e} /0.112/
ALPHAT Scale Parameter 1 of Timber Products in Utility Function /0.0358/
ALPHAP Scale Parameter 1 of Biodiversity in Utility Function  /0.0492/
ALPHAO Scale Parameter 1 of Other in Utility Function | alpha_{o}
BETAF Scale Parameter 2 of Food in Utility Function /0.023/
BETAL Scale Parameter 2 of Livestock in Utility Function /0.011/
BETAE Scale Parameter 2 of Energy in Utility Function | beta_{e} /0.049/
BETAT Scale Parameter 2 of Timber in Utility Function /0.0316/
BETAP Scale Parameter 2 of Biodiversity in Utility Function /0.104/
BETAO Scale Parameter 2 of Other in Utility Function | beta_{o}
GAMMAF Subsistence Parameter For Food in Utility Function | overline{f}  /0.45/
GAMMAL Subsistence Parameter For Livestock in Utility Function | overline{f} /0.003/
GAMMAE Subsistence Parameter For Energy in Utility Function | overline{e} /0.026/
GAMMAT Subsistence Parameter For Timber in Utility Function | overline{w}  /0.0265/
GAMMAP Subsistence Parameter For Rec. Services in Utility Function | overline{r} /0.028/
GAMMAO Subsistence Parameter For Other in Utility Function | overline{o} / 0.346/


* Time Preference

DELTA0 Social Discount Rate | 1 - delta /0.05/
gamma CRRA coefficient /2/

* Exogenous Parameters

EPSILON A Small Number / 0.0001 /
;


BFRHO = 1 -  (1 / BFSIGMA);
BMRHO = 1 -  (1 / BMSIGMA);
LRHO = 1 -  (1 / LSIGMA);
FTRHO = 1 -  (1 / FTSIGMA);
ALPHAO = 1 - ALPHAF - ALPHAL - ALPHAE - ALPHAT - ALPHAP;
BETAO = 1 - BETAF - BETAL - BETAE - BETAT - BETAP;
RECRHO = 1 - (1 / RECSIGMA);
RECALPHA3 = 1 - RECALPHA - RECALPHA1 - RECALPHA2;
YIELDTHH = 1.9 * YIELD0;
YIELDTHL = 1.9 * YIELD0 * 0.86;
YIELDTLH = 1.45 * YIELD0;
YIELDTLL = 1.45 * YIELD0 * 0.86;


PARAMETERS

PERIOD(t) periods
POP(t) Population in Billion People | Pi_{t}
YIELD(t) Agricultural Yield of Commercial Land in tons per Ha | theta^{c}_{t}
YIELD1(t) Agricultural Yield of Commercial Land under RCP 2.6 and good tech. progr.
YIELD2(t) Agricultural Yield of Commercial Land under RCP 8.5 and good tech. progr.
YIELD3(t) Agricultural Yield of Commercial Land under RCP 2.6 and bad tech. progr.
YIELD4(t) Agricultural Yield of Commercial Land under RCP 8.5 and bad tech. progr.
YIELDM(t) Cellulosic Feedstocks Yield in tons per Ha per annum | theta^{m}_{t}
YIELDGRM(t) Cellulosic Feedstocks Yield Growth Rate in tons per Ha per annum
FDPROD(t) Food Technology Index | theta^{f}_{t}
LPROD(t) Livestock Technology Index
FOSSILP(t) Price of Fossil Fuels in USD per toe | c^{x'e}_{t}
FFGR(t) Fixed Factor Growth of 2G biofuels Production
FOREST0(v) Total Area of Forest Land of Vintage v in Period 1 in GHa | L^{C}_{v'0}
FOPROD(v,t) Yield of Timber for vintage v in tons per Ha | theta^{w}_{v't}
TPROD(t) Timber Processing Technology | theta^{s}_{t}
ENEFF(t) Autonomous Energy Efficiency Improvement Rate | theta^{e}_{t}
RECPROD(t) Recreational Technology Index | theta^{o'R}_{t}
OTHER(t) Other Goods and Services in Economy | y^{o}_{t}
TFP(t) Total Factor productivity
DELTA(t) Social Discount Rate | delta^{t}
;

loop(t, PERIOD(t) = 2004 + deltat*(ord(t)-1));
POP(t)$(ord(t)<=Nsteady) = POP0*POPT*exp(POPGR1*deltat*(ord(t)-1))/(POPT+POP0*(exp(POPGR1*deltat*(ord(t)-1))-1));
POP(tSteady) = sum(t$(ord(t)=Nsteady), POP(t));
POP(t0) = POP0;


****************************

YIELD1(t)$(ord(t)<=Nsteady) = YIELD0*YIELDTHH*exp(YIELDGR*deltat*(ord(t)-1))/(YIELDTHH+YIELD0*(exp(YIELDGR*deltat*(ord(t)-1))-1));
YIELD1(tSteady) = sum(t$(ord(t)=Nsteady), YIELD1(t));
YIELD2(t)$(ord(t)<=Nsteady) = YIELD0*YIELDTHL*exp(YIELDGR*deltat*(ord(t)-1))/(YIELDTHL+YIELD0*(exp(YIELDGR*deltat*(ord(t)-1))-1));
YIELD2(tSteady) = sum(t$(ord(t)=Nsteady), YIELD2(t));
YIELD3(t)$(ord(t)<=Nsteady) = YIELD0*YIELDTLH*exp(YIELDGR*deltat*(ord(t)-1))/(YIELDTLH+YIELD0*(exp(YIELDGR*deltat*(ord(t)-1))-1));
YIELD3(tSteady) = sum(t$(ord(t)=Nsteady), YIELD3(t));
YIELD4(t)$(ord(t)<=Nsteady) = YIELD0*YIELDTLL*exp(YIELDGR*deltat*(ord(t)-1))/(YIELDTLL+YIELD0*(exp(YIELDGR*deltat*(ord(t)-1))-1));
YIELD4(tSteady) = sum(t$(ord(t)=Nsteady), YIELD4(t));

* We first solve the "optimistic scenario" case which is the problem without tipping points
YIELD(t) = YIELD1(t);

****************************


YIELDM(t)$(ord(t)<=Nsteady) = YIELDM0;
YIELDM(tSteady) = sum(t$(ord(t)=Nsteady), YIELDM(t));
FDPROD(t)$(ord(t)<=Nsteady) = FDPROD0*(1 + FDPRODGR)**(deltat*(ord(t)-1));
FDPROD(tSteady) = sum(t$(ord(t)=Nsteady), FDPROD(t));
LPROD(t)$(ord(t)<=Nsteady) = LPROD1*(1 + LPRODGR)**(deltat*(ord(t)-1));
LPROD(tSteady) = sum(t$(ord(t)=Nsteady), LPROD(t));
FOREST0(v) = 1.62 / card(v);
FORYA = 5.62;
FOPROD(v,t) = EPSILON/10;
FOPROD(v,t)$(ord(v) > 1 and ord(t) le 100/deltat) = exp(FORYA-FORYB/(deltat*(ord(v)-1)))*(1 + 0.011*deltat*(ord(t)-1));
FOPROD(v,t)$(ord(t) gt 100/deltat) = sum(t1$(ord(t1)=100/deltat), FOPROD(v,t1));
TPROD(t)$(ord(t)<=Nsteady) = TPROD0*((1+TPRODGR)**(deltat*(ord(t)-1)));
TPROD(tSteady) = sum(t$(ord(t)=Nsteady), TPROD(t));
ENEFF(t)$(ord(t)<=Nsteady) = (1+ENEFFGR)**(deltat*(ord(t)-1));
ENEFF(tSteady) = sum(t$(ord(t)=Nsteady), ENEFF(t));
FFGR(t) = (1+FIXEDFGR)**(deltat*(ord(t)-1));
FFGR(tSteady) = sum(t$(ord(t)=Nsteady), FFGR(t));
TFP(t)$(ord(t)<=Nsteady) = OPROD0*(1+TFPGR)**(deltat*(ord(t)-1));
TFP(tSteady) = sum(t$(ord(t)=Nsteady), TFP(t));
OTHER(t)$(ord(t)<=Nsteady) = OTHER0*(LABSHARE*(POP(t)/POP0)
+(1-LABSHARE)*(1+OTHERGR)**(deltat*(ord(t)-1)));
OTHER(tSteady) = sum(t$(ord(t)=Nsteady), OTHER(t));

DELTA(t) = (1-DELTA0)**(deltat*(ord(t)-1));

option decimals = 7;

display YIELD, FOPROD, FORYA, LPROD, LRHO;

**********************************************************************

* Endogenous Variables

Variables

UTIL(t) Utility Function | u(y_{t})
CLLAND(t) Amound of Pasture Land Converted to Crop Land | Delta^{A'P}
WELF total social Welfare;

Positive variables

NLAND(t) Stock of Natural Land in GHa | L^{N}
PLAND(t) Stock of Protected Land in GHa | L^{R}
CLAND(t) Flow of Natural Land Converted into Commercial Land in GHa | Delta^{N'A}
CPLAND(t) Flow of Natural Land Converted into Protected Land in GHa | Delta^{N'R}
ALAND(t) Agricultural Land in GHa  | L^{A}
MLAND(t)  Cellulosic Feedstocks Land in Gha  | L^{M}
CRLAND(t) Cropland in Gha | L^{F}
LLAND(t) Stock of Pasture Land in GHa | L^{P}
FLAND(v,t) Stock of Forestry Land of Vintage v in GHa | L^{C}
FHLAND(v,t) Flow of Harvested Forestry Land of Vintage v in GHa | Delta^{C'H}
FHLANDS(t)  Flow of Harvested Forestry Land in GHa | sum (v' Delta^{C'H})
FNLANDS(t)  Flow of Forestry Land Converted to Natural State in GHa | Delta^{C'N}
FLANDS(t) Total Forestry Land
REPLANTV(t) Flow of Replanted Forestry Land in GHa | Delta^{C'C}
APROD(t) Amount of Crops Produced in Gton | x^{c}
APRODM(t) Amount of Cellulosic Feedstocks Produced in Gton | x^{m}
TFOSSIL(t) Stock of Fossil fuels in Gtoe   | X^F
dFOSSIL(t) Fossil fuels extracted for combustion in Gtoe | Delta^F'E
dFERTIL(t) Fossil fuels extracted for fertilizers production in Gtoe Delta^F'N
FOSSILE(t) Quantity of Fossil Fuels Produced in Gtoe | x^{p}
FERTIL(t) Amount of Fertilizers used for Agricultural product in Gton | x^{n'c}
FERTILM(t) Amount of Fertilizers used for Cellulosic Feedstocks in Gton | x^{n'm}
FEED(t) Amount of Crop Products consumed as livestock feed  x^{c'l}
LIVPROD(t) Amount of Livestock Product Produced in Gton  | y^{l}
ENERGY(t) Amount of Energy Produced in GToe | y^{e}
FPROD(t) Amount of Timber Products in Gton |  y^{w}
FOOD(t) Amount of Agricultural Product Consumed as Food in Gton | y^{f}
BIOF(t) Amount of 1G Biofuels in Gtoe | x^{b}
BIOFM(t) Amount of 2G Biofuels in Gtoe | x^{m}
RECSERV(t) Amount of Recreation Services Produced | y^{r}
OTHERC(t) Amount of Other Goods and Services Per Capita Consumed in USD' 10000;

* Equations

EQUATIONS

CONVERSION(t) Natural Land Conversion Equation
ALANDTRAN(t) Agricultural Land Transition Equation
ALANDCOMP(t) Agricultural Land Composition
LLANDTRAN(t) Pasture Land Transition Equation
FLANDTRAN(v,t) Forestry Land Transition Equation
FLANDTRANLAST(v,t) Forestry Land Transition Equation for the last vintage
REPLANTRAN(t) Replanting Transition Equation
PLANDTRAN(t) Transition Equation for Protected Land
FHLANDSUM(t) Total Harvested Land
FLANDSUM(t) Total Forestry Land
EXTRACTION(t) Fossil Fuel Extraction Function
OTHERCON(t) Non-Land Endowment Constraint
APRODF(t) Agricultural Product's Production Function
APRODMF(t) Cellulosic Feedstocks Production Function
LPRODF(t) Livestock Production Function
FTPRODF(t) Fertilizers' Production Function
FPRODF(t) Forestry Production Function
BIOFPF(t) Biofuels Production Function
BIOFMPF(t) 2nd Gen. Biofuels Production Function
FOSSILPF(t) Fossil Fuels Production Function
ENERGYPF(t) Energy Production Fuction
RECSERVF(t) Recreation Services Production Function
UTILITY(t) Utlity Function
FHLANDUPPBND(v,t) upper bound of FHLAND
FNLANDUPPBND(t) upper bound of FNLAND
FOODCONS(t) Food sufficiency constraint
WELFARE Social Welfare;

**********************************************************************

* Land Use

CONVERSION(t)$(notT(t)) .. NLAND(t+1) =e= NLAND(t) - deltat*CLAND(t) - deltat*CPLAND(t) + deltat*FNLANDS(t);
PLANDTRAN(t)$(notT(t))  .. PLAND(t+1) =e= PLAND(t) + deltat*CPLAND(t);
ALANDTRAN(t)$(notT(t))  .. ALAND(t+1) =e= ALAND(t) + deltat*CLAND(t) - deltat*CLLAND(t) + deltat*FHLANDS(t) - deltat*REPLANTV(t);
LLANDTRAN(t)$(notT(t)) ..  LLAND(t+1) =e= LLAND(t) + deltat*CLLAND(t);
FLANDTRAN(v,t)$(ord(v)<card(v)-1 and notT(t)) .. FLAND(v+1,t+1) =e= FLAND(v,t) - deltat * FHLAND(v,t);
FLANDTRANLAST(v,t)$(ord(v)=card(v)-1 and notT(t)) .. FLAND(v+1,t+1) =e= FLAND(v+1,t) - deltat*(FHLAND(v+1,t)+FNLANDS(t)) + FLAND(v,t) - deltat*FHLAND(v,t);
REPLANTRAN(t)$(notT(t)) .. FLAND('1',t+1) =e= deltat*REPLANTV(t);
FHLANDSUM(t)$(notT(t)) .. FHLANDS(t) =e= sum(v, FHLAND(v,t));
FHLANDUPPBND(v,t)$(ord(v)<card(v) and notT(t)).. deltat*FHLAND(v,t) =l= FLAND(v,t);
*FNLANDUPPBND(t)$(notT(t)).. deltat*FNLANDS(t) =l= sum(v$(ord(v)=card(v)), FLAND(v,t)-FHLAND(v,t));
FNLANDUPPBND(t)$(notT(t)).. deltat*FNLANDS(t) =l= sum(v$(ord(v)=card(v)), FLAND(v,t)-deltat*FHLAND(v,t));
FLANDSUM(t)$(notT(t)).. FLANDS(t+1) =e= FLANDS(t) - deltat*FHLANDS(t) - deltat*FNLANDS(t) + deltat*REPLANTV(t);
ALANDCOMP(t)$(notT(t))  .. ALAND(t) =e= CRLAND(t) + MLAND(t);

* Fossil Fuel Use

EXTRACTION(t)$(notT(t)) .. TFOSSIL(t+1) =e= TFOSSIL(t) + deltat*OILGR - deltat*dFOSSIL(t) - deltat*dFERTIL(t);

* Other Endowment Constraint

OTHERCON(t)$(notT(t)) .. OTHERC(t) =e= TFP(t) * ( OTHER(t)
-(SHAREA*APROD(t)/YIELD(t) + SHAREM*APRODM(t)/YIELDM(t)
+ SHAREE * FOSSILE(t)
+ SHAREFE * (FERTIL(t) + FERTILM(t))
+ SHAREF * FOOD(t)/FDPROD(t) + SHAREL * LIVPROD(t) / LPROD(t)
+ SHAREFL * LIVPROD(t) * LPROD1 / LPROD(t)
+ LADJ * sqr(CLLAND(t))
+ SHARET/TPROD(t) * FPROD(t) + SHAREB * BIOF(t) + SHAREBM * BIOFM(t)
+ SHAREP * PLAND(t)
+ SHARERP * REPLANTV(t)
+ TSHAREFO*FHLANDS(t)
+ SHAREN * (CLAND(t)+CPLAND(t)) + CLGAMMA*sqr(CLAND(t)+CPLAND(t))
+ SHARECP * CPLAND(t) + RECADMCOST1*sqr(CPLAND(t))
+ SHAREFN * FNLANDS(t) + FNADMCOST*sqr(FNLANDS(t))
+ HARADJ * sqr(FHLANDS(t) - REPLANTV(t)) + sum(v, PENCUTALL/(FLAND(v,t+1)+PENCUTALL))
+ FOSADJ*sqr((dFOSSIL(t)+dFERTIL(t))) * (TFOSSIL0+OILGR)/(TFOSSIL(t)+OILGR)
)/OPROD0);

* Production

FTPRODF(t)$(notT(t)) .. FERTIL(t) + FERTILM(t) =e= 1000 * FERTPROD * dFERTIL(t);
APRODF(t)$(notT(t)) .. APROD(t) =e= YIELD(t) * (FTALPHA*(CRLAND(t))**FTRHO
+ (1-FTALPHA)*(FERTIL(t)**FTRHO))**(1/FTRHO);
APRODMF(t)$(notT(t)) .. APRODM(t) =l= YIELDM(t) * (FTALPHA*(MLAND(t))**FTRHO
+ (1-FTALPHA)*(FERTILM(t)**FTRHO))**(1/FTRHO);
LPRODF(t)$(notT(t)) .. LIVPROD(t) =e= LPROD0*LPROD(t) * (LALPHA*(LLAND(t))**LRHO
+ (1-LALPHA)*((FEED(t))**LRHO))**(1/LRHO);
FPRODF(t)$(notT(t)) .. FPROD(t) =e= TPROD(t) * (sum(v$(ord(v) gt 1), 0.5*(FOPROD(v,t)+FOPROD(v-1,t))*FHLAND(v,t)));
BIOFPF(t)$(notT(t)) .. BIOF(t) =e= BIOFPROD * (APROD(t) - FEED(t) - FOOD(t)/FDPROD(t));
BIOFMPF(t)$(notT(t)) .. BIOFM(t) =l= BIOFPRODM * (BMALPHA*(APRODM(t))**BMRHO +
((1-BMALPHA)** FFGR(t)) * (FIXED)**BMRHO)**(1/BMRHO);
FOSSILPF(t)$(notT(t)) .. FOSSILE(t) =e= 1000*FOSPROD0*dFOSSIL(t);
ENERGYPF(t)$(notT(t)) .. ENERGY(t) =l= ENEFF(t)* BFGAMMA * (BFALPHA*(BIOF(t))**BFRHO +
 (1 - BFALPHA) * ((FOSSILE(t) + BIOFM(t))**BFRHO))**(1/BFRHO);
RECSERVF(t)$(notT(t)) ..  RECSERV(t) =e= RECGAMMA * (RECALPHA*(ALAND(t))**RECRHO
+ RECALPHA1*(LLAND(t))**RECRHO  + RECALPHA2*(sum(v, FLAND(v,t)))**RECRHO
+ RECALPHA3*(NLAND(t) + RECPLANDP * PLAND(t))**RECRHO)**(1/RECRHO);

* implicit Utility

UTILITY(t) .. UTIL(t) =e= ( (ALPHAF*exp(-UTIL(t))+BETAF) * log(FOOD(t)/POP(t) - GAMMAF)
+ (ALPHAL*exp(-UTIL(t))+BETAL) * log(LIVPROD(t)/POP(t) - GAMMAL)
+ (ALPHAE*exp(-UTIL(t))+BETAE) * log(ENERGY(t)/POP(t) - GAMMAE)
+ (ALPHAT*exp(-UTIL(t))+BETAT) * log(FPROD(t)/POP(t) - GAMMAT)
+ (ALPHAP*exp(-UTIL(t))+BETAP) * log(RECSERV(t)/POP(t) - GAMMAP)
+ (ALPHAO*exp(-UTIL(t))+BETAO) * log(OTHERC(t)/POP(t) - GAMMAO) ) / (1 + exp(-UTIL(t)) );

* Food constraint

FOODCONS(t)$(notT(t)) .. 0 =l= FOOD(t) - GAMMAF * POP(t);

* Welfare

Welfare .. Welf =e= sum(t$(notT(t)), DELTA(t) * deltat * POP(t) * (exp((1-gamma)*UTIL(t))/(1-gamma)));

**********************************************************************

* Intermediate Bounds

NLAND.lo(m) = EPSILON;
NLAND.lo(tT) = EPSILON;
NLAND.up(m) = NLAND0;
NLAND.up(tT) = NLAND0;
PLAND.lo(m) = PLAND0;
PLAND.lo(tT) = PLAND0;
PLAND.up(m) = TLAND0;
PLAND.up(tT) = TLAND0;
ALAND.lo(t) = EPSILON;
ALAND.up(t) = TLAND0;
CRLAND.lo(t) = EPSILON;
CRLAND.up(t) = TLAND0;
MLAND.up(t) = TLAND0;
MLAND.lo(t) = 0.0001*ALAND0;
LLAND.lo(t) = EPSILON;
LLAND.up(t) = TLAND0;
FLAND.up(v,t) = TLAND0;
FLANDS.lo(t) = EPSILON;
FLANDS.up(t) = TLAND0;
CLAND.up(t) = TLAND0;
CLLAND.lo(t) = -TLAND0;
CLLAND.up(t) = TLAND0;
CPLAND.up(t) = TLAND0;
FHLAND.up(v,t) = TLAND0;
FHLANDS.up(t) = sum(v, FHLAND.up(v,t));
FNLANDS.up(t) = TLAND0;
REPLANTV.lo(t) = EPSILON;
REPLANTV.up(t) = TLAND0;
APROD.up(t) = 100000;
FEED.lo(t) = EPSILON;
FEED.up(t) = 100000;
LIVPROD.lo(t) = (GAMMAL + EPSILON)*POP(t);
LIVPROD.up(t) = 100000;
FPROD.lo(t) = (GAMMAT + EPSILON)*POP(t);
FPROD.up(t) = 100000;
FOOD.lo(t) = (GAMMAF + EPSILON)*POP(t);
FOOD.up(t) = 100000;
TFOSSIL.up(t) = 10;
dFOSSIL.up(t) = TFOSSIL0;
dFERTIL.up(t) = TFOSSIL0;
FOSSILE.up(t) = 10000;
FERTIL.lo(t) = EPSILON;
FERTIL.up(t) = 10000;
FERTILM.lo(t) = 0.1 * 0.075 * TFOSSIL0 / card(t);
FERTILM.up(t) = 10000;
BIOF.lo(t) = EPSILON;
BIOF.up(t) = 1000;
BIOFM.lo(t) = EPSILON;
BIOFM.up(t) = 1000;
ENERGY.lo(t) = (GAMMAE + EPSILON)*POP(t);
RECSERV.lo(t) = (GAMMAL + EPSILON)*POP(t);
RECSERV.up(t) = 100000;
OTHERC.lo(t) = (GAMMAO + EPSILON)*POP(t);
OTHERC.up(t) = TFP(t)*OTHER(t);

UTIL.lo(t) = -1000000;
UTIL.up(t) = 1000000;
WELF.lo = -100000;
WELF.up = 100000;

* Initial Guess

NLAND.l(t) = NLAND0;
PLAND.l(t) = PLAND0;
ALAND.l(t) = ALAND0;
CRLAND.l(t) = 0.99*ALAND0;
MLAND.l(t) = 0.01*ALAND0;
LLAND.l(t) = LLAND0;
CLAND.l(t) = 0;
CLLAND.l(t) = 0;
CPLAND.l(t) = 0;
dFOSSIL.l(t) = 0.925 * TFOSSIL0 / card(t);
dFOSSIL.l(tSteady) = 0.925 * OILGR;
dFERTIL.l(t) = 0.075 * TFOSSIL0 / card(t);
dFERTIL.l(tSteady) = 0.075 * OILGR;
TFOSSIL.l('1') = TFOSSIL0;
loop (t,
TFOSSIL.l(t+1) = TFOSSIL.l(t) + deltat*OILGR - deltat*dFOSSIL.l(t) - deltat*dFERTIL.l(t);
);
FLAND.l(v,t) = FOREST0(v);
FLANDS.l(t) = sum(v, FOREST0(v));
FHLAND.l(v,t) = 0;
FHLAND.l(vV,t) = FOREST0(vV);
FHLANDS.l(t) = sum(v, FHLAND.l(v,t));
FNLANDS.l(t) = 0;
FPROD.l(t) = TPROD(t) * (sum(v, 0.5*(FOPROD(v,t)+FOPROD(v-1,t))*FHLAND.l(v,t)));
FERTIL.l(t) = 999 * FERTPROD * dFERTIL.l(t);
FERTILM.l(t) = FERTPROD * dFERTIL.l(t);
APROD.l(t) = YIELD(t) * (FTALPHA*(CRLAND.l(t))**FTRHO
+ (1-FTALPHA)*(FERTIL.l(t)**FTRHO))**(1/FTRHO);
APRODM.l(t) = YIELDM(t) * (FTALPHA*(MLAND.l(t))**FTRHO
+ (1-FTALPHA)*(FERTILM.l(t)**FTRHO))**(1/FTRHO);
FEED.l(t) = 0.2 * APROD.l(t);
BIOF.l(t) = BIOF0;
FOOD.l(t) = FDPROD(t)* (APROD.l(t) - FEED.l(t)- BIOF0 /BIOFPROD);
LIVPROD.l(t) = LPROD0*LPROD(t) * (LALPHA*(LLAND.l(t))**LRHO
+ (1-LALPHA)*((FEED.l(t))**LRHO))**(1/LRHO);
FOSSILE.l(t) = 1000*FOSPROD0*dFOSSIL.l(t);
BIOFM.l(t) = BIOFPRODM * (BMALPHA*(APRODM.l(t))**BMRHO +
((1-BMALPHA)** FFGR(t)) * (FIXED)**BMRHO)**(1/BMRHO);
ENERGY.l(t) = ENEFF(t)* BFGAMMA * (BFALPHA*(BIOF.l(t))**BFRHO +
 (1 - BFALPHA) * ((FOSSILE.l(t) + BIOFM.l(t))**BFRHO))**(1/BFRHO);
RECSERV.l(t) = RECGAMMA * (RECALPHA*(ALAND.l(t))**RECRHO
+ RECALPHA1*(LLAND.l(t))**RECRHO  + RECALPHA2*(sum(v, FLAND.l(v,t)))**RECRHO
+ RECALPHA3*(NLAND.l(t) + RECPLANDP * PLAND.l(t))**RECRHO)**(1/RECRHO);
REPLANTV.l(t)  = sum(v, FHLAND.l(v,t));
OTHERC.l(t) = TFP(t)* ( OTHER(t) - (SHAREE * FOSSILE.l(t)
+ SHAREFE * (FERTIL.l(t) + FERTILM.l(t))
+ SHAREA * APROD.l(t)/YIELD(t) + SHAREM*APRODM.l(t)/YIELDM(t)
+ SHAREF * FOOD.l(t)/FDPROD(t) + SHARET/TPROD(t) * FPROD.l(t)
+ SHAREB * BIOF.l(t) + SHAREBM * BIOFM.l(t)
+ SHAREL * LIVPROD.l(t) / LPROD(t)
+ SHAREFL * LIVPROD.l(t) * LPROD1 / LPROD(t)
+ LADJ * sqr(CLLAND.l(t))
+ SHAREP * PLAND.l(t)
+ SHARERP * REPLANTV.l(t)
+ TSHAREFO*FHLANDS.l(t)
+ SHAREN * (CLAND.l(t)+CPLAND.l(t)) + CLGAMMA*sqr(CLAND.l(t)+CPLAND.l(t))
+ SHARECP * CPLAND.l(t) + RECADMCOST1*sqr(CPLAND.l(t))
+ SHAREFN * FNLANDS.l(t) + FNADMCOST*sqr(FNLANDS.l(t))
+ HARADJ * sqr(FHLANDS.l(t) - REPLANTV.l(t)) + sum(v, PENCUTALL/(FLAND.l(v,t+1)+ PENCUTALL))
+ FOSADJ * sqr((dFOSSIL.l(t)+dFERTIL.l(t))) * (TFOSSIL0+OILGR)/(TFOSSIL.l(t)+OILGR)
)/OPROD0);


**********************************************************************

* Starting Values

NLAND.fx(t0) = NLAND0;
PLAND.fx(t0) = PLAND0;
ALAND.fx(t0) = ALAND0;

LLAND.fx(t0) = LLAND0;
TFOSSIL.fx(t0) = TFOSSIL0;
FLAND.fx(v,t0) = FOREST0(v);
FLANDS.fx(t0) = sum(v, FOREST0(v));

**********************************************************************
* Model

Option limrow=0,limcol=0 ;
OPTION ITERLIM = 500000;
OPTION RESLIM = 500000;
OPTION DOMLIM = 1000;
OPTION NLP= conopt4;

model land / all /;

Parameters
OPTALAND(t) Agricultural Land in GHa
OPTNLAND(t) Natural Land in GHa
OPTLLAND(t) Pasture Land in GHa
OPTFLAND(t) Forest Land in GHa
OPTPLAND(t) Protected Land in GHa
OPTFHLAND(t) Harvested Forest Land in GHa
OPTFNLAND(t) Restored Forest Land in GHa
OPTREPLANT(t) Forest Area Replanted in GHa
OPTCLAND(t) Converted Natural Land Per in GHa
OPTCLLAND(t) Converted Pasture Land Per in GHa
OPTFOSSILE(t) FOSSILE
OPTAPROD(t) Agricultural Product in Gton
OPTAPRODM(t) Cellulosis Feedstocka in Gton
OPTFEED(t) Animal Feed in Gton
OPTFOOD(t) Food services
OPTLIVPROD(t) Livestock in ton
OPTFERTIL(t) Fertilizer's Intensity in tons per Ha
OPTFERTILM(t) Fertilizer's Intensity for cellulosic feedstocks in tons per Ha
OPTBIOF(t) Biofuels consumed in toe
OPTBIOFM(t) 2G Biofuels consumed in toe
OPTEN(t) Energy Service per Capita consumed in toe
OPTIMBER(t) Timber per Capita in 2004 USD
OPTRECSERV(t) Recreation Services in 2004 USD
TCLAND(t) Total Converted Land Per Capita in GHa
OPTFPROD(t) Forest Product in tons
OPTOTHERC(t) Consumption of Other G&S (Real Terms)
OPTdFOSSIL(t) Fossil Fuels Extracted
OPTTFOSSIL(t) Fossil Fuels Stock
OPTFOODLAND(t) Crop Land Dedicated to Food Crops
OPTFEEDLAND(t) Crop Land Dedicated to Animal Feed
OPTMLAND(t) Cellulosic Feedstocks Land in GHa
OPTCRLAND(t) Crop Land in GHa;

File results /F:\LandUse_ClimateImpactPaper\results2_fiveyear.csv/;
* File results /results1_fiveyear.csv/;
results.pc=5;
results.pw=4000;

option solprint=off;
solve land using nlp maximizing WELF;

YIELD(t) = YIELD4(t);
solve land using nlp maximizing WELF;

* Outputing Results

OPTALAND(t) = ALAND.l(t);
OPTLLAND(t) = LLAND.l(t);
OPTNLAND(t) = NLAND.l(t);
OPTPLAND(t) = PLAND.l(t);
OPTFLAND(t) = sum(v, FLAND.l(v,t)) + EPS;
OPTFHLAND(t) = sum(v, FHLAND.l(v,t)) + EPS;
OPTFNLAND(t) = FNLANDS.l(t) + EPS;
OPTREPLANT(t) = REPLANTV.l(t) + EPS;
OPTCLAND(t) = CLAND.l(t) + EPS;
OPTCLLAND(t) = CLLAND.l(t) + EPS;
OPTCRLAND(t) = CRLAND.l(t);
OPTMLAND(t) = MLAND.l(t) + EPS;
OPTFOSSILE(t) = FOSSILE.l(t);
OPTFERTIL(t) = FERTIL.l(t) / CRLAND.l(t);
OPTFERTILM(t) = FERTILM.l(t) / MLAND.l(t);
OPTAPROD(t) = APROD.l(t);
OPTAPRODM(t) = APRODM.l(t);
OPTFEED(t) = FEED.l(t) + EPS;
OPTFOOD(t) = FOOD.l(t) + EPS;
OPTLIVPROD(t) = LIVPROD.l(t) / LPROD(t) + EPS;
OPTBIOF(t) = BIOF.l(t) + EPS;
OPTBIOFM(t) = BIOFM.l(t) + EPS;
OPTIMBER(t) = EPS;
OPTRECSERV(t) = RECSERV.l(t)*1000;
OPTEN(t) = ENEFF(t) * (BIOF.l(t)+FOSSILE.l(t));
TCLAND(t) = sum(t1$(ord(t1) le ord(t)),OPTCLAND(t1));
OPTFPROD(t) = FPROD.l(t) / TPROD(t);
OPTOTHERC(t) = OTHERC.l(t) / TFP(t) + EPS;
OPTdFOSSIL(t) = dFOSSIL.l(t) + EPS;
OPTTFOSSIL(t) = TFOSSIL.l(t) + EPS;
OPTFEEDLAND(t) = ALAND.l(t) * (FEED.l(t) / APROD.l(t));
OPTFOODLAND(t) = ALAND.l(t) * (1 - (FEED.l(t) / APROD.l(t)));

display LPROD, OPTLIVPROD;

Put results;
Put / "FiveYear";
Loop (t, put period(t)::0);
Put / "ALAND";
Loop (t, put OPTALAND(t)::3);
Put / "NLAND";
Loop (t, put OPTNLAND(t)::3);
Put / "OPTFLAND";
Loop (t, put OPTFLAND(t)::3);
Put / "PLAND";
Loop (t, put OPTPLAND(t)::5);
Put / "OPTBIOF";
Loop (t, put OPTBIOF(t)::5);
Put / "OPTTFOSSIL";
Loop (t, put OPTTFOSSIL(t)::3);
Put / "FOSSILE";
Loop (t, put OPTFOSSILE(t)::3);
Put / "OPTFPROD";
Loop (t, put OPTFPROD(t)::2);
Put / "OPTREPLANT";
Loop (t, put OPTREPLANT(t)::3);
Put / "APROD";
Loop (t, put OPTAPROD(t)::3);
Put / "OPTCLAND";
Loop (t, put OPTCLAND(t)::5);
Put / "OPTFOOD";
Loop (t, put OPTFOOD(t)::3);
Put / "OPTFERTIL";
Loop (t, put OPTFERTIL(t)::3);
Put / "OPTdFOSSIL";
Loop (t, put OPTdFOSSIL(t)::5);
Put / "OPTOTHERC";
Loop (t, put OPTOTHERC(t)::2);
Put / "OPTIMBER";
Loop (t, put OPTIMBER(t)::2);
Put / "OPTRECSERV";
Loop (t, put OPTRECSERV(t)::2);
Put / "LLAND";
Loop (t, put OPTLLAND(t)::3);
Put / "CLLAND";
Loop (t, put OPTCLLAND(t)::5);
Put / "FEED";
Loop (t, put OPTFEED(t)::5);
Put / "LIVPROD";
Loop (t, put OPTLIVPROD(t)::5);
Put / "FNLAND";
Loop (t, put OPTFNLAND(t)::5)
Put / "FOODLAND";
Loop (t, put OPTFOODLAND(t)::5);
Put / "FEEDLAND";
Loop (t, put OPTFEEDLAND(t)::5);
Put / "CRLAND";
Loop (t, put OPTCRLAND(t)::5);
Put / "MLAND";
Loop (t, put OPTMLAND(t)::5);
Put / "APRODM";
Loop (t, put OPTAPRODM(t)::5);
Put / "BIOFM";
Loop (t, put OPTBIOFM(t)::5);
Put / "FERTILM";
Loop (t, put OPTFERTILM(t)::5);


**********************************************************************

* execute_unload "initguess1.gdx" WELF.l UTIL.l NLAND.l PLAND.l CLAND.l CPLAND.l
* ALAND.l FLAND.l FHLAND.l REPLANTV.l APROD.l FOSSILE.l
* FOSSILF.l FERTIL.l ENERGY.l FPROD.l FOOD.l BIOF.l RECSERV.l;

execute_unload "forest1_fiveyear.gdx" FLAND.l FHLAND.l;


File FHLANDres /FHLANDres_fiveyear.csv/;
FHLANDres.pc =5;
FHLANDres.pw=4000;
put FHLANDres;
loop(t$(ord(t)<=Nsteady),
  loop(v, put FHLAND.l(v,t)::5);
  put /;
);

File FNLANDres /FNLANDres_fiveyear.csv/;
FNLANDres.pc =5;
FNLANDres.pw=4000;
put FNLANDres;
loop(t$(ord(t)<=Nsteady),
  put FNLANDS.l(t)::5;
  put /;
);

File FLANDres /FLANDres_fiveyear.csv/;
FLANDres.pc =5;
FLANDres.pw=4000;
put FLANDres;
loop(t$(ord(t)<= Nsteady),
  loop(v, put FLAND.l(v,t)::5);
  put /;
);


***************
* Output solutions

parameter outPeriod / 21 /;

File sol_det /sol_det.csv/;
sol_det.pc=5;
sol_det.pw=4000;

Put sol_det;

Put "t";
put "Yield";
put "TFOSSIL";
put "Nland";
put "Pland";
put "Aland";
put "Crland";
put "Mland";
put "Lland";
put "Fland1";
put "Fland2";
put "Fland3";
put "Fland4";
put "Fland5";
put "Fland6";
put "Fland7";
put "Fland8";
put "Fland9";
put "Fland10";

put "dFOSSIL";
put "dFERTIL";
put "CLLAND";
put "CLAND";
put "CPLAND";
put "FHLANDS";
put "FNLANDS";
put "REPLANTV";

put "BIOF";
put "BIOFM";
put "APROD";
put "APRODM";
put "FOSSILE";
put "FERTIL";
put "FERTILM";
put "FEED";

put "FOOD";
put "LIVPROD";
put "ENERGY";
put "FPROD";
put "RECSERV";
put "OTHERC";

put /;
loop(t1$(ord(t1)<=outPeriod),
  put t1.tl::4;
  put YIELD(t1)::6;
  put TFOSSIL.l(t1)::6;
  put NLAND.l(t1)::6;
  put PLAND.l(t1)::6;
  put ALAND.l(t1)::6;
  put CRLAND.l(t1)::6;
  put MLAND.l(t1)::6;
  put LLAND.l(t1)::6;
  loop(v,
    put FLAND.l(v,t1)::6;
  );

  put dFOSSIL.l(t1)::6;
  put dFERTIL.l(t1)::6;
  put CLLAND.l(t1)::6;
  put CLAND.l(t1)::6;
  put CPLAND.l(t1)::6;
  put FHLANDS.l(t1)::6;
  put FNLANDS.l(t1)::6;
  put REPLANTV.l(t1)::6;

  put BIOF.l(t1)::6;
  put BIOFM.l(t1)::6;
  put APROD.l(t1)::6;
  put APRODM.l(t1)::6;
  put FOSSILE.l(t1)::6;
  put FERTIL.l(t1)::6;
  put FERTILM.l(t1)::6;
  put FEED.l(t1)::6;

  put FOOD.l(t1)::6;
  put LIVPROD.l(t1)::6;
  put ENERGY.l(t1)::6;
  put FPROD.l(t1)::6;
  put RECSERV.l(t1)::6;
  put OTHERC.l(t1)::6;

  put /;
);

