from airflow import DAG
from airflow.decorators import task
from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator
from datetime import datetime

from kubernetes.client import V1Volume, V1VolumeMount

volume = V1Volume(
    name="aws-creds",
    secret={"secret_name": "aws-creds"}
)
volume_mount = V1VolumeMount(
    name="aws-creds",
    mount_path="/root/.aws",
    read_only=True
)

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
        volumes=[volume],
        volume_mounts=[volume_mount],
    )

    start() >> run_dbt
