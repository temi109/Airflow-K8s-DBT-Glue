FROM public.ecr.aws/glue/aws-glue-libs:5

USER root

# Copy requirements and install with python3
COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Expose Jupyter port
EXPOSE 8888

USER glue_user
