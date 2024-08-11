# Variables
IMAGE_NAME = ecs-fluentbit-sidecar
IMAGE_TAG = 1.1.0
ECR_REGISTRY = public.ecr.aws/logzio
AWS_REGION = us-east-1
DOCKERFILE = Dockerfile
DOCKERFILEARM = Dockerfile.arm

.PHONY: all
all: login build-amd64 tag-amd64 push-amd64 build-arm64 tag-arm64 push-arm64

.PHONY: build
build-amd64:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) --platform linux/amd64 -f $(DOCKERFILE) .
build-arm64:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) --platform linux/arm64 -f $(DOCKERFILEARM) .
.PHONY: tag
tag-amd64:
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(ECR_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)-amd64
tag-arm64:
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(ECR_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)-arm64
.PHONY: push
push-amd64:
	docker push $(ECR_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)-amd64
push-arm64:
	docker push $(ECR_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)-arm64
.PHONY: login
login:
	aws ecr-public get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_REGISTRY)