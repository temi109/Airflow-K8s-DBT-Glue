import datetime
import time
from airflow.sdk import DAG, task

with DAG(
    dag_id="example_dag",
    start_date=datetime.datetime(2026, 2, 14),
    schedule="@daily",
    catchup=False
):

    @task
    def print_hello():
        time.sleep(5)
        print("Hello world!")

    @task
    def print_goodbye():
        time.sleep(5)
        print("Goodbye world!")
        

    print_hello() >> print_goodbye()
    