########################
Spring Cloud Config
########################

介绍
==========

Spring Cloud Config是Spring Cloud团队创建的一个全新项目，用来为分布式系统中的基础设施和微服务应用提供集中化的外部配置支持，它分为服务端和客户端两部分，其中服务端也称为分布式配置中心，它是一个独立的微服务应用，用来连接配置仓库并为客户端提供获取配置信息，加密/解密信息等访问接口，而客户端则是微服务架构中的各个微服务应用或基础设施，它们通过指定的配置中心管理应用资源与业务相关的配置内容，并在启动的时候从配置中心获取和加载配置信息。

配置Server
==================================

Spring Cloud Config服务端对应的组件是：spring-cloud-config-server

搭建项目
************
1. 添加spring-cloud-config-server依赖：

.. code-block:: xml
    :linenos:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-config-server</artifactId>
    </dependency>

2. 编辑文件application.properties:

.. code-block:: text
    :linenos:

    server.port=8888
    spring.application.name=cloud-config
    spring.cloud.config.server.git.uri=file://${user.home}/app-config-repo

注意：
# 属性spring.application.name的值cloud-config对应uri中的path。
# 属性spring.application.name的值同时对应uri属性路径中的文件名，这里表示在目录${user.home}/app-config-repo下，有文件 ``cloud-config-**.properties``

创建Git存储库
**************************

服务器存储后端的默认实现使用git，我们需要创建Git存储库作为配置存储

::

    $ cd $HOME
    $ mkdir app-config-repo
    $ cd app-config-repo
    $ git init .
    $ echo 'user.role=Dev' > cloud-config-development.properties
    $ echo 'user.role=Admin' > cloud-config-production.properties
    $ git add .
    $ git commit -m 'Initial application properties'

检验内容
**************************

1. 打开浏览器，访问地址：http://localhost:8888/cloud-config/development
2. 切换地址：http://localhost:8888/cloud-config/production


配置Client
==================================

Spring Cloud Config客户端对应的组件是：spring-cloud-starter-client

搭建项目
************

1. 添加spring-cloud-starter-client依赖：

.. code-block:: xml
    :linenos:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-client</artifactId>
    </dependency>

2. 编辑文件application.properties:

.. code-block:: text
    :linenos:

    spring.application.name=cloud-client
    spring.profiles.active=development
    spring.cloud.config.uri=http://localhost:8888


* 属性spring.application.name的值同时对应uri属性路径中的文件名，这里表示在目录${user.home}/app-config-repo下，有文件 ``cloud-client-**.properties``

3. 创建客户端Controller。

.. code-block:: java
    :linenos:

    package com.docedit.springcloudconfigserver;

    import org.springframework.beans.factory.annotation.Value;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    public class ConfigClientController {
        
        @Value("${user.role}")
        private String role;

        @GetMapping("/profile/{name}")
        public String getActiveProfile(@PathVariable String name) {
            return "Hello " + name + "! active profile name is " + role;
        }

    }

创建客户端属性文件
****************************************************
这里，需要创建 ``cloud-client-**.properties`` 文件::

    $ cd $HOME
    $ cd app-config-repo
    $ echo 'user.role=abc123' > cloud-client.properties
    $ git add .
    $ git commit -m 'add application properties'


检验内容
**************************

1. 打开浏览器，访问地址：http://localhost:8080/profile/murphy，页面将显示::

    Hello murphy! active profile name is abc123




