# Export values for airflow docker image

export IMAGE_NAME=my-dags
export IMAGE_TAG=0.0.7
export NAMESPACE=airflow
export RELEASE_NAME=airflow


# Build the image and load it to kind cluster

docker build --pull --tag $IMAGE_NAME:$IMAGE_TAG -f cicd/Dockerfile .
kind load docker-image $IMAGE_NAME:$IMAGE_TAG --name airflow-cluster



# Upgrade airflow using helm

helm upgrade $RELEASE_NAME apache-airflow/airflow  \
    -n $NAMESPACE -f chart/values-override.yaml \
    --set images.airflow.tag=$IMAGE_TAG \
    --debug


# Port forward the API server to access the Airflow UI
kubectl port-forward svc/$RELEASE_NAME-api-server 8080:8080 -n $NAMESPACE
