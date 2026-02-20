from airflow import DAG
from airflow.decorators import task
from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator
from datetime import datetime

from kubernetes.client import V1EnvVar, V1EnvVarSource, V1SecretKeySelector

# volume = V1Volume(
#     name="aws-creds",
#     secret={"secret_name": "aws-credentials"}
# )
# volume_mount = V1VolumeMount(
#     name="aws-creds",
#     mount_path="/root/.aws",
#     read_only=True
# )

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
        in_cluster=True,
        env_vars=[
            V1EnvVar(
                name="AWS_ACCESS_KEY_ID",
                value_from=V1EnvVarSource(
                    secret_key_ref=V1SecretKeySelector(
                        name="aws-credentials",
                        key="AWS_ACCESS_KEY_ID"
                    )
                )
            ),
            V1EnvVar(
                name="AWS_SECRET_ACCESS_KEY",
                value_from=V1EnvVarSource(
                    secret_key_ref=V1SecretKeySelector(
                        name="aws-credentials",
                        key="AWS_SECRET_ACCESS_KEY"
                    )
                )
            ),
            V1EnvVar(
                name="AWS_DEFAULT_REGION",
                value_from=V1EnvVarSource(
                    secret_key_ref=V1SecretKeySelector(
                        name="aws-credentials",
                        key="AWS_DEFAULT_REGION"
                    )
                )
            ),
        ],
    )

    start() >> run_dbt
