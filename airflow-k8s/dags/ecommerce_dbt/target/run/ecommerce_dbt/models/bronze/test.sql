
  
    create or replace table glue_catalog.bronze.test
          
          
      
    using iceberg
      
      
      
      LOCATION 's3://ti-dbt-glue-database-bucket-12345/glue-db-output/bronze/test'
      
      as
      
    


SELECT 
    *,
    current_timestamp() as ingested_date
FROM bronze.customers
  

  