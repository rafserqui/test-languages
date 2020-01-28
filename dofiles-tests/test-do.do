/*
THIS CODE PLOTS AT THE MUNICIPALITY LEVEL USING DATA FROM IPUMS-I:
	1.- SECTORAL EMPLOYMENT SHARES AGAINST LOG(GDPpc)
	2.- SECTORAL EMPLOYMENT SHARES AGAINST ELECTRICITY ACCESS 
	3.- POPULATION DENSITY AGAINST ELECTRICITY ACCESS
*/

clear
set more off
graph set window fontface default
if "`c(username)'" == "rafse" {
    global root "C:/Users/`c(username)'/Documents/RESEARCH/brazil-spatial-model/"
  }
  if "`c(username)'" == "Rafael"  {
    global root "D:/RESEARCH/brazil-spatial-model/"
  }
global stata "$root/code/stata/"
global data "$root/data/IPUMS Data/"
global paper "$root/tex/"
global figures "$paper/figures/"
global tables "$paper/tables/"

cd "$stata/"

use "$data/spatial/ipums_meters_merge", replace

set scheme uncluttered_publication
grstyle init
grstyle color major_grid dimgray
grstyle linewidth major_grid thin
grstyle yesno draw_major_hgrid no
grstyle yesno grid_draw_min yes
grstyle yesno grid_draw_max yes
