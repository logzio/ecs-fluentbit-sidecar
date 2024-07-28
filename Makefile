# Variables
IMAGE_NAME = ecs-fluentbit-sidecar
IMAGE_TAG = 1.0.8-test-amd64
ECR_REGISTRY = public.ecr.aws/logzio
AWS_REGION = us-east-1
DOCKERFILE = Dockerfile

.PHONY: all
all: login build tag push

.PHONY: build
build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) --platform linux/amd64 -f $(DOCKERFILE) .

.PHONY: tag
tag:
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(ECR_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

push:
	docker push $(ECR_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

login:
	aws ecr-public get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_REGISTRY)