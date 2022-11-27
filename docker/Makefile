TAG=0.0.1-alpha
GEOSERVER_VERSION=2.22.0
IMAGE_NAME=github.com/felipelfraga/geoserver-cloud

.PHONY: build run runsh sh kill

build:
	docker build \
	--build-arg GEOSERVER_VERSION=$(GEOSERVER_VERSION) \
	--tag $(IMAGE_NAME):$(TAG) .

run:
	docker run -v geoserver-shapefiles:/shapefiles -p 8080:8080 -it --rm $(IMAGE_NAME):$(TAG)

runsh:
	docker run -v geoserver-shapefiles:/shapefiles -p 8080:8080 -it --rm $(IMAGE_NAME):$(TAG) /bin/bash

sh:
	docker exec -it $$(docker ps --format '{{.Names}} {{.Image}}' | grep -m 1 ${IMAGE_NAME}:${TAG} | cut -d" " -f1) /bin/bash

kill:
	docker kill $$(docker ps --format '{{.Names}} {{.Image}}' | grep -m 1 ${IMAGE_NAME}:${TAG} | cut -d" " -f1)
