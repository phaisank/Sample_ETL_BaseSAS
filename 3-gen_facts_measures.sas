/* -------------------------------------------------
 * 3. Generate intermediate Fact table, FACTS_MEASURES
 * by derive another measure from FACTS_DATE_IDS
 * Mapping:
 * facts_date_ids       >   facts_measures
 * 
 * ------------------------------------------------- */

data facts_measures;
    set facts_date_ids;

    *format values;
    format PRICE 8.2;
    format
        QUANTITY 8.0;
    format
        REVENUE 8.2;

    /* quantity modifier is a value which applies model assumptions regarding */
    /* differencies between amount of products sold to retailers vs wholesalers, etc. */
    q_modifier=1;

    /*seeds are sold in higher quantities than plants*/
    if prod_type=1 then
        q_modifier=q_modifier*3;

    /*wholesalers buy more than retailers*/
    if cust_segment='Wholesale' then
        q_modifier=q_modifier*10;

    /* Nurseries buy more than other wholesalers */
    if cust_group='Nurseries' then
        q_modifier=q_modifier*20;

    /* younger plants are bought in bigger quantities */
    if prod_age>1 then
        do;
            q_modifier=10*q_modifier*(1/(prod_age**2));
        end;

    *calculate FINAL RANDOM QUANTITY with the use of modifier;
    QUANTITY=int(1+q_modifier*abs(rannor(456)));

    /*seeds are packed by 10*/
    if prod_type=1 then
        QUANTITY=QUANTITY*10;

    /*calculate FINAL PRICE*/
    /*price is low for seeds (idp=1) and is getting higher with age */
    PRICE = (idp**0.3)*((prod_age)**4)/5;

    /*calculate REVENUE*/
    REVENUE=price*quantity;
run;

/*test the newly generated data*/
PROC MEANS data=facts_measures
    mean min max MAXDEC=2
    nonobs;
    class cust_group prod_age;
    var quantity;
RUN;