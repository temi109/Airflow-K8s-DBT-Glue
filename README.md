# Airflow + Kubernetes + dbt + AWS Glue Data Platform

## Overview

This project demonstrates a cloud-native data platform architecture that orchestrates scalable data transformation workflows using Apache Airflow, Kubernetes, dbt, and AWS Glue.

The platform is designed to reflect real-world modern data engineering practices, where orchestration, compute, and transformation layers are decoupled and scalable. Airflow acts as the workflow orchestrator, dynamically launching containerised workloads inside Kubernetes using the KubernetesPodOperator. These containers run dbt transformations which are executed on AWS Glue's serverless Spark environment, allowing the pipeline to process large-scale datasets without managing infrastructure.

The project demonstrates how organisations can build production-style ELT pipelines that support scalable analytics, maintain modular transformation logic, and integrate seamlessly with cloud-native infrastructure.


The pipeline architecture separates orchestration, transformation, and compute into independent layers to maximise scalability and maintainability.

## Data Flow

### Workflow Orchestration

- **Apache Airflow** manages pipeline DAGs
- Tasks are executed using the `KubernetesPodOperator`
- Airflow schedules, monitors, and retries workflows

### Container Orchestration

- **Kubernetes** provides the execution environment for Airflow tasks
- Each dbt task runs inside a temporary pod
- Secrets and credentials are managed through Kubernetes secrets

### Transformation Layer

- **dbt** defines transformation logic using modular SQL models
- Models are version-controlled and organised into reusable transformations

### Distributed Compute

- **AWS Glue** provides serverless Spark execution
- Glue allows transformations to scale automatically without managing Spark clusters


# Architecture

<p align="center">
  <a href="https://raw.githubusercontent.com/temi109/Airflow-K8s-DBT-Glue/main/images/Airflow%20%2B%20Kubernetes%20%2B%20dbt%20%2B%20AWS%20Glue%20Data%20Platform.png">
    <img src="https://raw.githubusercontent.com/temi109/Airflow-K8s-DBT-Glue/main/images/Airflow%20%2B%20Kubernetes%20%2B%20dbt%20%2B%20AWS%20Glue%20Data%20Platform.png" width="100%">
  </a>
</p>


# Data Pipeline Flow

1. **Airflow DAG is triggered**
2. Airflow launches a **Kubernetes pod** using `KubernetesPodOperator`
3. The pod runs a **dbt command**
4. dbt submits transformations to **AWS Glue**
5. Glue executes distributed Spark jobs
6. Results are materialised as analytics-ready datasets


---

# Key Features

### Cloud-native orchestration
Airflow running on Kubernetes for scalable task execution.

### Containerised workloads
Tasks executed inside ephemeral pods.

### Serverless compute
Transformations executed on AWS Glue Spark.

### Modular transformations
dbt models structured for maintainability.

### Infrastructure decoupling
Orchestration, compute, and transformation layers are separated.

---

# Project Goals

This project was built to demonstrate how a **modern data platform can be architected using cloud-native tooling** commonly used in production environments.

The project focuses on:

- Building **scalable ELT pipelines**
- Demonstrating **Kubernetes-native orchestration patterns**
- Integrating **dbt with serverless Spark environments**
- Implementing **reproducible containerised workflows**
