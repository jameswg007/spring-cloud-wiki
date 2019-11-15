########################
Spring Boot Actuator
########################

Actuator介绍
==================

在本节中，我们将介绍Spring Boot Actuator。 我们将首先介绍基础知识，然后详细讨论Spring Boot 1.x和2.x中的可用内容。

本质上，Actuator为Spring Boot的应用带来了监控生产应用的功能：监视应用程序，收集指标，了解流量或数据库状态。
Actuator的主要好处是，我们可以获得生产级工具，而不必自己真正实现这些功能。Actuator主要用于公开有关正在运行的应用程序的操作信息-运行状况，指标，信息，dump，环境等。它使用HTTP endpoints或JMX Bean使我们能够与其交互。

一旦Actuator的依赖关系位于类路径classpath上，用户可以立即使用某些endpoints。 与大多数Spring模块一样，我们可以通过多种方式轻松地对其进行配置或扩展。


启用Actuator
====================

要在您的应用程序中启用Spring Boot Actuator，您必须在包管理器中添加Spring Boot Actuator依赖项。通过添加Starter依赖项spring-boot-starter-actuator，这是在Spring应用程序中启用actuator功能的最简单方法。

* Maven工程中：

 .. code-block:: xml
    :linenos:

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
    </dependencies>

* Gradle工程中：

 .. code-block:: groovy
    :linenos:

    dependencies {
        compile("org.springframework.boot: spring-boot-starter-actuator")
    }


Spring Boot 1.X 中的Actuator
======================================

在1.x中，执行器遵循 R/W 模型，这意味着我们可以对其进行读取或写入。例如，我们可以检索指标或应用程序的运行状况。 另外，我们可以优雅地终止我们的应用程序或更改日志记录配置。

为了使其工作，Actuator要求Spring MVC通过HTTP公开其endpoints。 不支持其他技术。

在1.x中，Actuator带来了自己的安全模型。 它利用了Spring Security安全架构，但是需要与应用程序的其余部分独立配置。而且，大多数endpoints都是sensitive状态，即私密的，这意味着它们不是完全公开的，换句话说，大多数信息将被省略。 例如：/metrics。

分析Actuator的接口
*********************************

In 1.x, Here are some of the most common endpoints Boot provides out of the box:

* /health – Shows application health information (a simple ‘status' when accessed over an unauthenticated connection or full message details when authenticated); it's not sensitive by default
* /info – Displays arbitrary application info; not sensitive by default
* /metrics – Shows ‘metrics' information for the current application; it's also sensitive by default
* /trace – Displays trace information (by default the last few HTTP requests)

我们可以在官方文档中找到现有endpoints的完整列表。https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#production-ready-endpoints

显示配置细节
*********************************

http://localhost:8080/health

利用接口显示指标
*********************************

.. code-block:: text
    :linenos:

    endpoints.metrics.sensitive=false
    endpoints.metrics.enabled=true

http://localhost:8080/metrics

显示应用程序信息
*********************************

.. code-block:: text
    :linenos:

    info.app.name=Spring Sample Application
    info.app.description=This is my first spring boot application
    info.app.version=1.0.0

关闭应用程序
*********************************

自定义Actuator
*********************************

.. code-block:: java
    :linenos:

    package com.docedit.fsd;

    import org.springframework.boot.actuate.health.Health;
    import org.springframework.boot.actuate.health.HealthIndicator;
    import org.springframework.stereotype.Component;

    @Component
    public class HealthCheck implements HealthIndicator {

        @Override
        public Health health() {
            int errorCode = check(); // perform some specific health check
            if (errorCode != 0) {
                return Health.down().withDetail("Error Code", errorCode).build();
            }
            return Health.up().build();
        }

        public int check() {
            // Our logic to check health
            System.out.println("Our logic to check health");
            return 0;
        }
    }


启用或禁用某个Actuator接口
------------------------------------
endpoints.beans.enabled=true

更改接口ID
------------------------------------

endpoints.beans.id=springbeans

更改Actuator接口的灵敏度
------------------------------------

endpoints.beans.sensitive=false

编写自定义健康指标
------------------------------------
1. 启用metrics

 .. code-block:: text
    :linenos:

    endpoints.metrics.sensitive=false
    endpoints.metrics.enabled=true

2. 编写CounterService

 .. code-block:: java
    :linenos:

    package com.docedit.fsd;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.actuate.health.Health;
    import org.springframework.boot.actuate.health.HealthIndicator;
    import org.springframework.boot.actuate.metrics.CounterService;
    import org.springframework.stereotype.Component;

    @Component
    public class HealthCheck implements HealthIndicator {

        @Autowired
        private CounterService counterService;

        @Override
        public Health health() {
            int errorCode = check(); // perform some specific health check
            if (errorCode != 0) {
                return Health.down().withDetail("Error Code", errorCode).build();
            }
            return Health.up().build();
        }

        public int check() {
            // Our logic to check health
            System.out.println("Our logic to check health");
            counterService.increment("counter.login.success"); // test gather custom metrics,
            counterService.increment("counter.login.failure"); // test gather custom metrics
            return 0;
        }
    }

3. 访问 http://localhost:8080/health 目的是触发counterService.increment方法。
4. 接着访问 http://localhost:8080/metrics ， 显示下面的指标信息::

    "counter.login.failure":1,"counter.login.success":1,"counter.status.200.health":1

创建一个自定义Endpoint
*********************************

1. 创建CustomEndpoint

 .. code-block:: java
    :linenos:

    @Component
    public class CustomEndpoint implements Endpoint<List<String>> {
        
        @Override
        public String getId() {
            return "customEndpoint";
        }
    
        @Override
        public boolean isEnabled() {
            return true;
        }
    
        @Override
        public boolean isSensitive() {
            return true;
        }
    
        @Override
        public List<String> invoke() {
            // Custom logic to build the output
            List<String> messages = new ArrayList<String>();
            messages.add("This is message 1");
            messages.add("This is message 2");
            return messages;
        }
    }

2. 接着访问 http://localhost:8080/customEndpoint，或者用CURL检查::

    curl -H 'Content-Type:application/json' http://localhost:8080/customEndpoint

对Actuator接口进行安全控制
*********************************

在1.x中。 Actuator基于Spring Security配置其自己的安全模型，但与应用程序的其余部分无关。
默认情况下，除 /info 外的所有内置Endpoint都是私密的。 如果应用程序使用的是Spring Security，我们可以通过在application.properties文件中定义默认的安全属性（用户名，密码和角色）来保护这些endpoints::

    security.user.name=admin
    security.user.password=secret
    management.security.role=SUPERUSER

添加security依赖：

.. code-block:: xml
    :linenos:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>



Further Customization
*********************************

为了安全起见，我们可能选择通过非标准端口公开Actuator endpoints。可以使用management.port属性进行配置。

.. code-block:: text
    :linenos:

    #port used to expose actuator
    management.port=8081 
    
    #CIDR allowed to hit actuator
    management.address=127.0.0.1 
    
    #Whether security should be enabled or disabled altogether
    management.security.enabled=false

Spring Boot 2.X 中的Actuator
=======================================

在2.x中，默认情况下，现在所有Actuator endpoints都放在 /actuator 路径下，且只有两个默认是公开的 /health 和 /info，其他的默认是私密的。

我们使用新的属性management.endpoints.web.base-path来调整默认的actuator路径。


分析Actuator的接口
*********************************

* /auditevents – lists security audit-related events such as user login/logout. Also, we can filter by principal or type among others fields
* /beans – returns all available beans in our BeanFactory. Unlike /auditevents, it doesn't support filtering
* /conditions – formerly known as /autoconfig, builds a report of conditions around auto-configuration
* /configprops – allows us to fetch all @ConfigurationProperties beans
* /env – returns the current environment properties. Additionally, we can retrieve single properties
* /flyway – provides details about our Flyway database migrations
* /health – summarises the health status of our application
* /heapdump – builds and returns a heap dump from the JVM used by our application
* /info – returns general information. It might be custom data, build information or details about the latest commit
* /liquibase – behaves like /flyway but for Liquibase
* /logfile – returns ordinary application logs
* /loggers – enables us to query and modify the logging level of our application
* /metrics – details metrics of our application. This might include generic metrics as well as custom ones
* /prometheus – returns metrics like the previous one, but formatted to work with a Prometheus server
* /scheduledtasks – provides details about every scheduled task within our application
* /sessions – lists HTTP sessions given we are using Spring Session
* /shutdown – performs a graceful shutdown of the application
* /threaddump – dumps the thread information of the underlying JVM


在Spring Boot 2.0中，内部metrics已被Micrometer支持所取代。 因此，如果我们的应用程序使用的是GaugeService或CounterService，则它们将不再可用。


启用或禁用某个Endpoint
------------------------------------
如果要启用所有这些功能，可以设置::

    management.endpoints.web.exposure.include=*

要显式启用特定endpoint（例如 /shutdown），我们使用::

    management.endpoint.shutdown.enabled=true
    
或者我们可以列出应启用的具体endpoints::

    management.endpoints.web.exposure.include=beans,metrics

要公开排除一个（例如 /loggers）以外的所有启用的endpoints，我们使用::

    management.endpoints.web.exposure.include=*
    management.endpoints.web.exposure.exclude=loggers

创建一个自定义endpoint
*********************************

.. code-block:: java
    :linenos:

    package com.docedit.fsd;

    import org.springframework.boot.actuate.endpoint.annotation.Endpoint;
    import org.springframework.boot.actuate.endpoint.annotation.ReadOperation;
    import org.springframework.stereotype.Component;

    @Endpoint(id="mypoint")
    @Component
    public class MyPointEndPoint {
        @ReadOperation
        public String mypoint(){
            return "Hello" ;
        }
    }

我们可以使用以下声明定义操作：

* @ReadOperation – 对应 HTTP GET
* @WriteOperation – 对应 HTTP POST
* @DeleteOperation – 对应 HTTP DELETE

显示git详细信息
*********************************

1. 添加git plugin。

.. code-block:: xml
    :linenos:

    <plugin>
        <groupId>pl.project13.maven</groupId>
        <artifactId>git-commit-id-plugin</artifactId>
        <configuration>
            <dotGitDirectory>${project.basedir}/.git</dotGitDirectory>
        </configuration>
    </plugin>

2. 执行mvn clean package命令后，将会生成文件：target/classes/git.properties ::

    macbook-pro:fsd2.x murphy$ cat target/classes/git.properties 
    #Generated by Git-Commit-Id-Plugin
    #Fri Oct 11 15:17:12 CST 2019
    git.branch=master
    git.build.host=macbook-pro.cn.ibm.com
    git.build.time=2019-10-11T15\:17\:12+0800
    git.build.user.email=lanzejun@cn.ibm.com
    git.build.user.name=lanzejun
    git.build.version=0.0.1-SNAPSHOT
    git.closest.tag.commit.count=
    git.closest.tag.name=
    git.commit.id=60201666e9ec6088da5072c1b19c27f686cc9a2c
    git.commit.id.abbrev=6020166
    git.commit.id.describe=6020166-dirty
    git.commit.id.describe-short=6020166-dirty
    git.commit.message.full=update
    git.commit.message.short=update
    git.commit.time=2019-10-09T17\:02\:28+0800
    git.commit.user.email=lanzejun@cn.ibm.com
    git.commit.user.name=lanzejun
    git.dirty=true
    git.remote.origin.url=git@github.ibm.com\:lanzejun/fullstack.git
    git.tags=
    git.total.commit.count=70

3. 查看info： http://localhost:8080/actuator/info，默认情况下，显示的节点信息仅有3个。

指定git地址
--------------------------

.. code-block:: xml
    :linenos:

    <configuration>
        <dotGitDirectory>${project.basedir}/.git</dotGitDirectory>
    </configuration>

其中${project.basedir}指的是当前项目的根目录。

显示全部信息
--------------------------
在application.properties文件中，添加::

    management.info.git.mode=full

关闭git.properties文件的创建
------------------------------
在configuration中添加::

    <generateGitPropertiesFile>false</generateGitPropertiesFile>

Verbosity
------------------------------
显示细粒度的日志信息，在configuration中添加::

    <verbose>true</verbose>

过滤敏感信息
------------------------------
在configuration中添加:

.. code-block:: xml
    :linenos:

    <excludeProperties>
        <excludeProperty>git.user.*</excludeProperty>
    </excludeProperties>



对Actuator接口进行安全控制
*********************************

Actuator与常规Spring Security规则共享安全配置。因此，要调整Actuator安全性规则，我们可以为路径添加一个例外，如：/actuator/** :

添加security依赖：

.. code-block:: xml
    :linenos:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>


.. code-block:: java
    :linenos:

    @Bean
    public SecurityWebFilterChain securityWebFilterChain(
    ServerHttpSecurity http) {
        return http.authorizeExchange()
        .pathMatchers("/actuator/**").permitAll()
        .anyExchange().authenticated()
        .and().build();
    }

spring-boot-admin
=====================
https://www.baeldung.com/spring-boot-admin

参考
=====================

* https://docs.spring.io/spring-boot/docs/2.2.0.BUILD-SNAPSHOT/reference/html/production-ready-features.html#production-ready-endpoints
* https://docs.spring.io/spring-boot/docs/2.0.x/actuator-api/html/
* https://www.baeldung.com/spring-boot-security-autoconfiguration

小结
=========