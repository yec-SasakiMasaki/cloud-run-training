PROJECT_ID :=
NAME :=
APP_NAME := ws-flask-app
IMAGE_TAG := asia-northeast1-docker.pkg.dev/${PROJECT_ID}/${NAME}/${APP_NAME}:latest

gc-set:
	gcloud config set project $(PROJECT_ID)

build:
	docker build -t ${APP_NAME}:local .

run:
	docker run -p 8080:8080 \
		-v $(pwd)/app:/app \
		-e DEBUG=true \
		${APP_NAME}:local

test:
	docker build -t $(IMAGE_TAG) .
	docker run -p 8080:8080 -e PORT=8080 ${IMAGE_TAG}

push:
	docker build -t $(IMAGE_TAG) .
	docker push $(IMAGE_TAG)

deploy:
	gcloud run deploy cloud-run-${NAME} \
		--image ${IMAGE_TAG} \
		--region asia-northeast1
