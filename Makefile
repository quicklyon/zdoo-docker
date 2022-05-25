export TAG := $(shell grep base VERSION | cut -d '=' -f 2)
export TAG_BIZ := $(shell grep biz VERSION | cut -d '=' -f 2)
export TAG_CASH := $(shell grep cash VERSION | cut -d '=' -f 2)
export TAG_FLOW := $(shell grep flow VERSION | cut -d '=' -f 2)

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build-all: build build-biz build-cash build-flow ## 构建 [所有版本] 镜像

build: ## 构建 [基础版] 镜像
	docker build --build-arg VERSION=$(TAG) -t hub.qucheng.com/app/zdoo:$(TAG) -f Dockerfile .

build-biz: ## 构建 [企业版] 镜像
	docker build --build-arg VERSION=$(TAG_BIZ) -t hub.qucheng.com/app/zdoo:$(TAG_BIZ) -f Dockerfile .

build-cash: ## 构建 [记账版] 镜像
	docker build --build-arg VERSION=$(TAG_CASH) -t hub.qucheng.com/app/zdoo:$(TAG_CASH) -f Dockerfile .

build-flow: ## 构建 [工作流版] 镜像
	docker build --build-arg VERSION=$(TAG_FLOW) -t hub.qucheng.com/app/zdoo:$(TAG_FLOW) -f Dockerfile .

push-all: push push-biz push-cash push-flow ## 将所有镜像push到镜像仓库

push: ## push [基础版] 镜像
	docker push hub.qucheng.com/app/zdoo:$(TAG)

push-biz: ## push [企业版] 镜像
	docker push hub.qucheng.com/app/zdoo:$(TAG_BIZ)

push-cash: ## push [记账版] 镜像
	docker push hub.qucheng.com/app/zdoo:$(TAG_CASH)

push-flow: ## push [工作流版] 镜像
	docker push hub.qucheng.com/app/zdoo:$(TAG_FLOW)

run: ## 运行开源版
	docker-compose -f docker-compose.yml up -d

run-biz: ## 运行企业版
	docker-compose -f docker-compose.yml up -d

run-cash: ## 运行记账版
	docker-compose -f docker-compose.yml up -d

run-flow: ## 运行工作流版
	docker-compose -f docker-compose.yml up -d

ps: ## 运行状态
	docker-compose -f docker-compose.yml ps

stop: ## 停服务
	docker-compose -f docker-compose.yml stop

restart: build clean ps ## 重构

clean: stop ## 停服务
	docker-compose -f docker-compose.yml down
	docker volume prune -f

logs: ## 查看运行日志
	docker-compose -f docker-compose.yml logs
