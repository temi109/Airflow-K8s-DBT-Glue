from airflow import DAG
from airflow.decorators import task
from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator
from datetime import datetime

with DAG(
    dag_id="dbt_k8s_run",
    start_date=datetime(2026, 2, 19),
    schedule=None,
    catchup=False,
) as dag:

    @task
    def start():
        print("Starting DAG")

    run_dbt = KubernetesPodOperator(
        task_id="run_dbt",
        name="dbt-runner",
        namespace="airflow",
        image="airflow-dbt:latest",
        image_pull_policy="IfNotPresent",
        cmds=["bash"],
        arguments=["-c", "sleep infinity"],
        get_logs=True,
        is_delete_operator_pod=False,
        in_cluster=True,
    )

    start() >> run_dbt
