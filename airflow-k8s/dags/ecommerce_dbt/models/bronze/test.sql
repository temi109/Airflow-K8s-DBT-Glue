{{ config(
    materialized='table'
) }}


SELECT 
    *,
    current_timestamp() as ingested_date
FROM {{ source('bronze', 'customers') }}