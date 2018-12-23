GIT_SHA := $(shell git rev-parse --short HEAD)

# set COMPOSE_PROJECT_NAME to prevent docker-compose conflicts when running parallel builds on the same agent
ifdef BUILD_NUMBER
	BUILD_VERSION := $(FEATURE_NAME)-$(GIT_SHA)
	IS_ENV_CLEAN_REQUIRED = cleanEnv 
	COMPOSE_PROJECT_NAME=$(JOB_NAME)-$(STAGE_NAME)
else
	BUILD_VERSION?=local
endif

# this directive will make $(BUILD_VERSION) accessible as a normal env var
export
REGISTRY_HOST ?= github.com
IMAGE_NAME ?= $(REGISTRY_HOST)/helderklemp/${APP_NAME}
APP_URL ?= https://${APP_DNS}


##################
# PUBLIC TARGETS #
##################
build: $(IS_ENV_CLEAN_REQUIRED) .env
	@docker-compose down -v
	docker-compose run --rm builder mvn clean package -DskipTests

publishSonar: .env
	docker-compose run --rm builder mvn sonar:sonar -Dsonar.login="$(SONAR_AUTH)"

integrationTest: .env
	docker-compose run --rm builder mvn integration-test -Dgroups=IntegrationTest

dockerBuild: 
	docker build -t $(IMAGE_NAME):$(BUILD_VERSION) .

dockerScan: .env
	@docker-compose down -v
	docker-compose up -d clair 
	docker-compose exec -T clair /wait-for-it.sh localhost:6060 -- clair-scanner $(IMAGE_NAME):$(BUILD_VERSION)

dockerPush:
	docker push $(IMAGE_NAME):$(BUILD_VERSION)

dockerPushLatest:
	docker pull $(IMAGE_NAME):$(BUILD_VERSION)
	docker tag $(IMAGE_NAME):$(BUILD_VERSION) $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):latest

dockerLogin:
	docker login $(REGISTRY_HOST)  -u "$(REGISTRY_USERNAME)" -p "$(REGISTRY_PASSWORD)"

deploy: .env
	docker-compose run --rm builder sh -c "envsubst < k8s-config/deployment.tmpl.yml > k8s-config/deployment.yml"
	docker-compose run --rm kubectl kubectl apply -f k8s-config/deployment.yml
	docker-compose run --rm kubectl kubectl rollout status deployment/$(APP_NAME)-deployment-$(FEATURE_NAME)
	docker-compose run --rm kubectl sh -c "echo 'Application is accessible via: $(APP_URL)'"
	
kubeLogin: .env
	docker-compose pull kubectl
	docker-compose run --rm kubectl /usr/local/bin/k8s_login.sh

systemTest: .env
	@docker-compose down -v
	docker-compose run --rm selenium-runner mvn test -Dgroups=SystemTest

###########
# ENVFILE #
###########
.env:
	@echo "Create .env with .env.template"
# due to https://github.com/docker/compose/issues/6206 .env must exist before running anything with docker-compose
# we also ignore errors with '-' because "permission denied" probably means the file already exists, and disable output with '@'
	-@echo "" >> .env
# we must run cp in docker because Windows does not have cp
	@docker-compose down -v
	docker-compose run --rm builder cp .env.template .env

cleanEnv:
	-@echo "" >> .env
	@docker-compose down -v
	docker-compose run --rm builder rm -f .env
