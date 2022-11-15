export APP_NAME=zdoo
export VERSION := $(shell cat VERSION)
export BUILD_DATE := $(shell date +'%Y%m%d')
export TAG=$(VERSION)-$(BUILD_DATE)

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## 构建 [基础版] 镜像
	docker build --build-arg VERSION=$(VERSION) --build-arg IS_CHINA="true" -t hub.qucheng.com/app/$(APP_NAME):$(TAG) -f Dockerfile .

docker-build: ## 构建 [基础版] 镜像
	docker build --build-arg VERSION=$(VERSION) -t easysoft/$(APP_NAME):$(TAG) -f Dockerfile .


push: ## push [基础版] 镜像
	docker push hub.qucheng.com/app/$(APP_NAME):$(TAG)

docker-push: ## push [基础版] 镜像
	docker tag easysoft/$(APP_NAME):$(TAG) easysoft/$(APP_NAME):latest
	docker push easysoft/$(APP_NAME):$(TAG) 
	docker push easysoft/$(APP_NAME):latest

push-sync-tcr: docker-push ## 同步到腾讯镜像仓库
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):latest
	curl http://i.haogs.cn:3839/sync?image=easysoft/$(APP_NAME):$(TAG)

run: ## 运行开源版
	export TAG=$(TAG);docker-compose -f docker-compose.yml up -d

ps: ## 运行状态
	export TAG=$(TAG);docker-compose -f docker-compose.yml ps

stop: ## 停服务
	export TAG=$(TAG);docker-compose -f docker-compose.yml stop
	export TAG=$(TAG);docker-compose -f docker-compose.yml rm -f

restart: build clean ps ## 重构

clean: stop ## 停服务
	export TAG=$(TAG);docker-compose -f docker-compose.yml down
	docker volume prune -f

logs: ## 查看运行日志
	export TAG=$(TAG);docker-compose -f docker-compose.yml logs
