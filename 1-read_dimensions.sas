/* -------------------------------------------------
 * 1. Read Data from Raw Files
 * Mapping:
 * src_customers.csv    >   Customers
 * src_product.csv      >   products
 * src_countries.csv    >   countries
 * (manually enter)     >   prodtype
 * (manually enter)     >   prodage
 * 
 * ------------------------------------------------- */

* read customers definition from a csv file;
%LET SRC=C:\Lab\ETL-TOOLS_INFO;

data customers;
    infile "&SRC.\src_customers.csv" delimiter = ','
        MISSOVER firstobs=2;
    informat idc 8.0
        informat CUST_ID $6.;
    informat CUST_NAME $30.;
    informat CUST_GROUP $20.;
    informat CUST_SEGMENT $20.;
    informat CUST_COUNTRY_ID $2.;
    input ID CUST_ID CUST_NAME CUST_GROUP CUST_SEGMENT CUST_COUNTRY_ID;
    idc = _n_;

    * this variable will be used as a surrogate key;
    drop ID;
run;

* read products definition from a csv file;
data products;
    infile "&SRC.\src_products.csv" delimiter = ','
        MISSOVER firstobs=2;
    informat idp 8.0;
    informat PROD_ID $7.    
        informat PROD_NAME $30.;
    informat PROD_NAME_ENGLISH $30.;
    informat PROD_ZONE $15.;
    informat PROD_GROUP $15.;
    idp = _n_;

    * this variable will be used as a surrogate key;
    input PROD_ID PROD_NAME  PROD_NAME_ENGLISH PROD_ZONE PROD_GROUP;
run;

* read countries definition from a csv file;
data  countries;
    infile "&SRC.\src_countries.csv" delimiter = ',' 
        DSD MISSOVER firstobs=2;
    informat COUNTRY_ID $2.    
        informat COUNTRY_TEXT $50.;
    informat REGION_TEXT $30.;
    input COUNTRY_ID COUNTRY_TEXT REGION_TEXT;
run;

* enter manually product types;
data prodtype;
/*    infile datalines dlm=',';*/
    input type_id type_name & $20.;
    cards
    ;
    1 Seeds2 Plants
    ;
run;

* enter manually product age types;
data prodage;
    infile datalines dlm=',';
    input age_id age_name $ 8.;
    datalines
    ;
    1,0
    2,1-2
    3,3-5
    4,6-10
    5,11-20
    6,21-100
    ;
run;


