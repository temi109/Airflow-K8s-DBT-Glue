# Create or Replace a kind cluster

kind delete cluster --name airflow-cluster
kind create cluster --image kindest/node:v1.24.0 --name airflow-cluster

# Add airflow to my helm repo

helm repo add apache-airflow https://airflow.apache.org
helm repo update
helm show values apache-airflow/airflow > chart/airflow_values.yaml

# Export values for airflow docker image

export IMAGE_NAME=my-dags
export IMAGE_TAG=0.0.0
export NAMESPACE=airflow
export RELEASE_NAME=airflow

# Build the image and load it to kind cluster

docker build --pull --tag $IMAGE_NAME:$IMAGE_TAG -f cicd/Dockerfile .
kind load docker-image $IMAGE_NAME:$IMAGE_TAG --name airflow-cluster


# Create a namespace for airflow

kubectl create namespace $NAMESPACE


# Apply Kubernetes secrets for git sync

kubectl apply -f k8s/secrets/git-secrets.yml


# Install airflow using helm

helm install $RELEASE_NAME apache-airflow/airflow  \
    -n $NAMESPACE -f chart/values-override.yaml \
    --set images.airflow.tag=$IMAGE_TAG \
    --debug 
    # --timeout 15m \


# Port forward the API server to access the Airflow UI
kubectl port-forward svc/$RELEASE_NAME-api-server 8080:8080 -n $NAMESPACE

