/* -------------------------------------------------
 * 4. Generate final Fact Table, SALES_FACTS
 * Mapping:
 * facts_measures, Customers, Products, ProdAge, ProdType   >   Sales_Facts
 * Customers, Countries     >   Dim_Customers
 * Products                 >   Dim_Products
 * 
 * ------------------------------------------------- */

/*we can use SQL procedure to join the tables together using inner joins and create a final fact table */
proc sql;
    CREATE TABLE Sales_Facts AS
        SELECT
            fm.DT as DT, cus.cust_id as CUST_ID, prd.PROD_ID as PROD_ID, pa.age_name as PROD_AGE, pt.type_name as PROD_TYPE, fm.PRICE, fm.QUANTITY, fm.REVENUE   
        FROM facts_measures fm,  Customers cus, 
            Products prd,
            ProdAge pa,
            ProdType pt 
        WHERE
            fm.idc=cus.idc   AND
            fm.idp=prd.idp   AND
            fm.prod_age=pa.age_id   AND
            fm.prod_type=pt.type_id ORDER BY DT;
quit;

/* we also need a customer table joined with countries */
proc sql;
    CREATE TABLE Dim_Customers AS
        SELECT cus.CUST_ID, cus.CUST_NAME, cus.CUST_GROUP, cus.CUST_SEGMENT, cus.CUST_COUNTRY_ID, reg.COUNTRY_TEXT, reg.REGION_TEXT  
        FROM Customers cus,  Countries reg
        WHERE cus.CUST_COUNTRY_ID=reg.COUNTRY_ID;

/* products dimension table can be copied easily using a SAS dataset */
data Dim_Products;
    set products(drop=idp);

    * drop the idp column which will not be used;
run;

