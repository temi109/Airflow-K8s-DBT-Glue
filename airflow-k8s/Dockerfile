FROM python:3.11-slim

WORKDIR /opt/airflow/

# system deps
RUN apt-get update && apt-get install -y git gcc

# install dbt + athena adapter
RUN pip install --no-cache-dir \
    dbt-glue==1.10.15 \
    dbt-core==1.10.15
    
# copy project
COPY ./dags/ecommerce_dbt /opt/airflow/ecommerce_dbt

# dbt expects this
ENV DBT_PROFILES_DIR=/opt/airflow/ecommerce_dbt

CMD ["dbt", "run"]
