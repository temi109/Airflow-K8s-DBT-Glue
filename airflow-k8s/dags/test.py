from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator
from datetime import datetime
import datetime
import time
from airflow.sdk import DAG, task


with DAG(
    dag_id="dbt_k8s_run",
    start_date=datetime.datetime(2026, 2, 14),
    schedule="@daily",
    catchup=False
):
    @task
    def test():
        dbt_run = KubernetesPodOperator(
        task_id="run_dbt",
        name="dbt-runner",
        namespace="airflow",
        image="airflow-dbt:latest",
        cmds=["dbt"],
        arguments=["run"],
        get_logs=True,
        is_delete_operator_pod=True,
    )
        
    test()