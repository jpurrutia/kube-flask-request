install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

lint:
	sudo docker run --rm pyfound/black:latest_release black --version
	docker run --rm --volume $(pwd):/src --workdir /src pyfound/black:latest_release black --check .

test:
	python -m pytest -vv --cov=app test_app.py

build:
	sudo docker build -t mlb-schedule:latest .


run:
	sudo docker run -p 8080:8080 mlb-schedule

invoke:
	curl http://127.0.0.1:8080/schedule/2023-08-11

image-export:
	sudo docker save mlb-schedule | bzip2 > flask-mlb-schedule.bz2

copy-image:
	sudo scp -i $(minikube ssh-key) mlb-schedule.bz2 docker@$(minikube ip):/home/docker/mlb-schedule.bz2

run-kube:
	kubectl apply -f kube-hello-change.yaml

create-ip:
	minikube service

minikube-invoke:
	curl http://192.168.59.102:32000//change/1/340

all: install lint test