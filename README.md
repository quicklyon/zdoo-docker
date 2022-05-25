# ZDoo官方Docker镜像

[toc]

## 一、关于ZDoo

ZDOO全协同办公系统涵盖了OA日常办公、CRM客户管理、现金流记账、文档管理、项目管理、团队分享、应用导航以及后台管理等应用模块，主要面向中小团队的企业内部管理。和市面上其他的产品相比，ZDOO更专注于为企业提供一体化、精简、高效的办公管理解决方案。

随着互联网的发展，企业内部信息化管理的重要程度越来越高。企业信息化管理的水平决定了整个企业的运转效率和响应速度。我们团队也曾尝试了各种各样的管理软件，比如crm，oa等等。但遗憾的是这些软件大都功能冗杂晦涩，面目可憎。既然没有合适的轮子，那我们就自己来做自己的轮子吧。于是我们从2013年开始筹划准备，在2013年底正式启动ZDOO这个项目。我们的目的就是希望给众多的中小企业提供一个一体化的、精简的企业内部管理的解决方案。有了ZDOO，企业无需再搭建各种各样的crm系统，oa系统，论坛啊之类的，用一个软件即可解决企业不同应用场景的核心问题，帮助企业全面提升信息化、数字化管理水平。

官网：https://www.zdoo.com/


## 二、支持的标签
- 基础版：6.9.1
- 企业版：5.7.4
- 记账版：1.0
- 工作流版：1.0

## 三、获取镜像
推荐从 [Docker Hub Registry](https://hub.docker.com/r/easysoft/zdoo) 拉取我们构建好的官方Docker镜像【目前提供国内加速镜像地址】
```bash
docker pull hub.qucheng.com/app/zdoo:6.9.1
```

如需使用指定的版本，可以拉取一个包含版本标签的镜像，在Docker Hub仓库中查看 [可用版本列表](https://hub.docker.com/r/easysoft/zdoo/tags/) 

```bash
docker pull hub.qucheng.com/app/zdoo:[TAG]
```

## 四、持久化数据
如果你删除容器，所有的数据都将被删除，下次运行镜像时会重新初始化数据。为了避免数据丢失，你应该为容器提供一个挂在卷，这样可以将数据进行持久化存储。

为了数据持久化，你应该挂载持久化目录：

- /data zdoo持久化数据

如果挂载的目录为空，首次启动会自动初始化相关文件

```bash
$ docker run -it \
    -v $PWD/data:/data \
docker pull hub.qucheng.com/app/zdoo:6.9.1
```

或者修改 docker-compose.yml 文件，添加持久化目录配置

```bash
services:
  zdoo:
  ...
    volumes:
      - /path/to/zentao-persistence:/data
  ...
```
## 五、环境变量

| 变量名           | 默认值        | 说明                             |
| ---------------- | ------------- | -------------------------------- |
| DEBUG            | NULL         | 是否打开调试信息，默认关闭       |
| PHP_SESSION_TYPE | files         | php session 类型，files \| redis |
| PHP_SESSION_PATH | /data/session | php session 存储路径             |
| MYSQL_HOST       | 127.0.0.1     | MySQL 主机地址                   |
| MYSQL_PORT       | 3306          | MySQL 端口                       |
| MYSQL_DATABASE   | zdoo          | zentao数据库名称                 |
| MYSQL_USER       | root          | MySQL用户名                      |
| MYSQL_PASSWORD   | pass4zDoo   | MySQL密码                        |


## 六、运行 
### 6.1 单机Docker-compose方式运行

通过Docker-compse运行，默认会运行一个独立的MySQL服务，相关命令如下：

```bash
# 启动服务（zentao和mysql）
make run

# 查看服务状态
make ps

# 查看服务日志
docker-compose logs -f zdoo  # 查看zentao日志
docker-compose logs -f mysql # 查看mysql日志
```

> **说明：**
>
> - 通过docker-compose运行，会拉取mysql镜像，并运行
> - 启动成功后，打开浏览器输入 `http://<你的IP>:8081` 通过向导页面进行安装