FROM python:3.11-slim

WORKDIR /usr/app

# system deps
RUN apt-get update && apt-get install -y git gcc

# install dbt + athena adapter
RUN pip install --no-cache-dir \
    apache-airflow>=3.1.7 \
    dbt-glue==1.10.15 \
    dbt-core==1.10.15
# copy project
COPY . /usr/app

# dbt expects this
ENV DBT_PROFILES_DIR=/usr/app

CMD ["dbt", "run"]
