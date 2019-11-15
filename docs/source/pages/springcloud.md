########################
Spring Cloud
########################

原生云应用程序架构
====================================
问题集：https://www.javainuse.com/spring/spring-cloud-interview-questions

微服务架构
*********************************
微服务的优点
*********************************
微服务面临的挑战
*********************************
简介
====================================

Spring Cloud是一系列框架的有序集合。它利用Spring Boot的开发便利性巧妙地简化了分布式系统基础设施的开发，如服务发现注册、配置中心、消息总线、负载均衡、断路器、数据监控等，都可以用Spring Boot的开发风格做到一键启动和部署。Spring并没有重复制造轮子，它只是将目前各家公司开发的比较成熟、经得起实际考验的服务框架组合起来，通过Spring Boot风格进行再封装屏蔽掉了复杂的配置和实现原理，最终给开发者留出了一套简单易懂、易部署和易维护的分布式系统开发工具包。



云和微服务程序的构造块
*********************************
Spring Cloud应用
*********************************
配置Spring Cloud应用程序
====================================

Spring Cloud是一个总括项目，由原则上具有不同发布节奏的独立项目组成。 为了管理项目组合，将发布BOM（物料清单），并带有对单个项目的精选依赖关系集（请参见下文）。 发行列车使用名称而不是版本，以避免与子项目混淆。 名称是按字母顺序排列的（因此您可以按时间顺序对其进行排序），带有伦敦地铁站的名称（“ Angel”是第一个发行版，“ Brixton”是第二个发行版）。 当各个项目的点发布积累到一定数量时，或者其中一个关键错误需要所有人使用时，发布培训将推出名称以“ .SRX”结尾的“服务版本”， 其中“ X”是数字。

.. list-table:: Spring Cloud RELEASE版本
    :widths: 10 10
    :header-rows: 1

    * - RELEASE名称
      - 对应Spring Boot的版本
    * - Hoxton
      - 2.2.x
    * - Greenwich
      - 2.1.x
    * - Finchley
      - 2.0.x
    * - Edgware
      - 1.5.x
    * - Dalston
      - 1.5.x

比如（注意高亮行）：

.. code-block:: text
    :emphasize-lines: 9,21,47
    :linenos:

    <?xml version="1.0" encoding="UTF-8"?>
    <project xmlns="http://maven.apache.org/POM/4.0.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <parent>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-parent</artifactId>
            <version>2.1.9.RELEASE</version>
            <relativePath /> <!-- lookup parent from repository -->
        </parent>
        <groupId>com.docedit</groupId>
        <artifactId>spring-cloud-config-server</artifactId>
        <version>0.0.1-SNAPSHOT</version>
        <name>spring-cloud-config-server</name>
        <description>Demo project for Spring Boot</descripti·on>

        <properties>
            <java.version>1.8</java.version>
            <maven-jar-plugin.version>3.1.1</maven-jar-plugin.version>
            <spring-cloud.version>Greenwich.RELEASE</spring-cloud.version>
        </properties>

        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter</artifactId>
            </dependency>

            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-config-server</artifactId>
            </dependency>

            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-test</artifactId>
                <scope>test</scope>
            </dependency>
        </dependencies>

        <dependencyManagement>
            <dependencies>
                <dependency>
                    <groupId>org.springframework.cloud</groupId>
                    <artifactId>spring-cloud-dependencies</artifactId>
                    <version>${spring-cloud.version}</version>
                    <type>pom</type>
                    <scope>import</scope>
                </dependency>
            </dependencies>
        </dependencyManagement>

        <build>
            <plugins>
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                </plugin>
            </plugins>
        </build>

    </project>


小结
==================