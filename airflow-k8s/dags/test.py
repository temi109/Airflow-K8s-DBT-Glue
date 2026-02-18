from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator
from datetime import datetime


with DAG(
    dag_id="dbt_k8s_run",
    start_date=datetime(2024,1,1),
    schedule=None,
    catchup=False,
):

    dbt_run = KubernetesPodOperator(
        task_id="run_dbt",
        name="dbt-runner",
        namespace="default",
        image="airflow-dbt:latest",
        cmds=["dbt"],
        arguments=["run"],
        get_logs=True,
        is_delete_operator_pod=True,
    )