/* -------------------------------------------------
 * OVERVIEW
 * -------------------------------------------------
 * 1. Read Data from Raw Files
 * Mapping:
 * src_customers.csv    >   customers
 * src_product.csv      >   products
 * src_countries.csv    >   countries
 * (manually enter)     >   prodtype
 * (manually enter)     >   prodage
 * -------------------------------------------------
 * 2. Generate FACTS_DATE_IDS
 * Mapping:
 * (Generating)     >   prep_facts_date_ids
 * prep_facts_date_ids, customers   > facts_date_ids
 * -------------------------------------------------
 * 3. Generate intermediate Fact table, FACTS_MEASURES
 * Mapping:
 * facts_date_ids       >   facts_measures
 * -------------------------------------------------
 * 4. Generate final Fact Table, SALES_FACTS
 * Mapping:
 * facts_measures, Customers, Products, ProdAge, ProdType   >   Sales_Facts
 * Customers, Countries     >   Dim_Customers
 * Products                 >   Dim_Products
 * -------------------------------------------------
 * 5. Generate Analyzed Table from Fact Table: SALES_FACTS
 * Mapping:
 * sales_facts      >   fixcost
 * fixcost          >   fixcosts
 * sales_facts      >   varcost
 * varcost          >   varcosts
 * ------------------------------------------------- */

%LET SRC=C:\Users\t1pkana\Documents\Lib\ETL-TOOLS_INFO;

* run all programs in an ETL sequence ;

/*%include 'D:\business_scenario\1-read_dimensions.sas';*/
/*%include 'D:\business_scenario\2-gen_facts_date_ids.sas';*/
/*%include 'D:\business_scenario\3-gen_facts_measures.sas';*/
/*%include 'D:\business_scenario\4-create-fact-table.sas'; */
/*%include 'D:\business_scenario\5-gen-costs.sas';*/
 
* Use PROC MEANS to analyze populated figures ;
* We will check sum, average, min & max values of all measures ;
* the MAXDEC parameter indicates that we want to limit numbers to 2 decimal places ;
 
/* MAXDEC=2;*/
PROC MEANS data=Sales_Facts mean min max sum
 MAXDEC=2;

class prod_type prod_age;

var price revenue quantity ;

RUN;



/* ---------------------------------------------------------
 * from step(4):
 * extract the dimensions and facts tables into csv files 
 * which will be used for processing
 * --------------------------------------------------------- */

/*proc export data=Sales_Facts outfile="&SRC.\sales-cognosbi.csv" dbms=csv replace;*/
/*run;*/
/* */
/*proc export data=Dim_Customers outfile="&SRC.\dim_customers.csv" dbms=csv replace;*/
/*run;*/
/* */
/*proc export data=Dim_Products outfile="&SRC.\dim_products.csv" dbms=csv replace;*/
/*run;*/

/* ---------------------------------------------------------
 * from step(5):
 * Generate costs extracts 
 * --------------------------------------------------------- */

/*proc export data=fixcosts  outfile="&SRC.\f_fixcost.csv"  dbms=csv replace;*/
/*run;*/
/* */
/*proc export  data=varcosts  outfile="&SRC.\f_varcost.csv"  dbms=csv replace;*/
/*run;*/
