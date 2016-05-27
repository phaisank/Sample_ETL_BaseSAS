/* -------------------------------------------------
 * 5. Generate Analyzed Table from Fact Table: SALES_FACTS
 * Mapping:
 * sales_facts      >   fixcost
 * fixcost          >   fixcosts
 * sales_facts      >   varcost
 * varcost          >   varcosts
 * 
 * ------------------------------------------------- */

* CALCULATE FIXED COST;
* create a temporary table with total revenue which will be an input to the fix cost calculation;
proc  sql;
    create table fixcost as
        select min(year(dt)) as yr, sum(revenue) as tot_revenue from  sales_facts;
quit;

/* populate the fix costs which would be around 40 percent of all sales, growing each year  */
data fixcosts(keep=yr fixcost);
    set fixcost;
    obs_to_populate=3;

    * we will populate three years of data;
    format fixcost 8.2;

    * fixed cost base record taken from the first record beeing 40% of the revenue;
    base_fixcost = 0.4
        *(tot_revenue/obs_to_populate);

    *total revenue divided by number of years;
    fixcost=round(base_fixcost,500);

    * round the result to 500;
    output;

    * output the first base record;
    * populate data for the following years;
    DO i=2 TO obs_to_populate;
        yr+1;

        /* increase year */
        *calculate a random cost increase ranging from 0 to 15 percent;
        costincr=1+0.15
            *ranuni(i);

        *calculate the final fix cost;
        fixcost=round(fixcost*costincr,500);
        OUTPUT;

        * write to the output table;
    END;
run;

* CALCULATE VARIABLE COST;
* create a temporary varcost table;
proc sql;
    create table varcost as
        select distinct month(dt) as mth, 
            year(dt) as yr,
            sum(revenue) as mth_revenue 
        from Sales_Facts
            order by mth, yr;
quit;

/* generate random variable costs which will be around 20 percent of monthly sales */
data varcosts(keep=newdt varcost);
    set varcost;

    * format the date to a mm-yyyy format;
    format newdt mmyyd7.;
    format varcost 8.2;

    * create a date which is the first day of each month;
    newdt=mdy(mth,1,yr);

    * delta which is based on a normal distribution random number generator (can be positive or negative);
    delta = rannor(0)*mth_revenue*0.05;

    * calculate the final variable cost;
    varcost=0.2*mth_revenue+delta;
run;

