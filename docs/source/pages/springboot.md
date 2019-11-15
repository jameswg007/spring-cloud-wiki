########################
Spring Boot 2.x 学习
########################

Spring Boot 概述
==============================

* 创建独立的Spring应用程序
* 直接嵌入Tomcat，Jetty或Undertow（无需部署WAR文件）
* 提供集成的“starter”依赖项，以简化构建配置
* 尽可能自动配置Spring和3rd Party库
* 提供生产就绪的功能，例如指标，运行状况检查和外部配置
* 完全没有代码生成，也不需要XML配置（最低配置或零配置）
* 约定大于配置


常规概念
==============
* Endpoints
* Adapter
* RestFul API
* Controller + Service + Repository + Entity（3种状态）
* Configuration
* Spring Core, Spring IOC, Spring Boot, Spring Data JPA, Spring AOP, Spring Security, Spring Transaction, Spring JDBC, Spring MVC, Spring Integration and Hibernate ORM.

PO
*****
persistant object持久对象

最形象的理解就是一个PO就是数据库中的一条记录。
好处是可以把一条记录作为一个对象处理，可以方便的转为其它对象。

BO
*****
business object业务对象

主要作用是把业务逻辑封装为一个对象。这个对象可以包括一个或多个其它的对象。
比如一个简历，有教育经历、工作经历、社会关系等等。
我们可以把教育经历对应一个PO，工作经历对应一个PO，社会关系对应一个PO。

建立一个对应简历的BO对象处理简历，每个BO包含这些PO。
这样处理业务逻辑时，我们就可以针对BO去处理。

VO
*****

value object值对象
ViewObject表现层对象

主要对应界面显示的数据对象。对于一个WEB页面，或者SWT、SWING的一个界面，用一个VO对象对应整个界面的值。

POJO
*****

plain ordinary java object 简单java对象
个人感觉POJO是最常见最多变的对象，是一个中间对象，也是我们最常打交道的对象。

* 一个POJO持久化以后就是PO
* 直接用它传递、传递过程中就是DTO
* 直接用来对应表示层就是VO

DTO
*****

Data Transfer Object数据传输对象
主要用于远程调用等需要大量传输对象的地方。
比如我们一张表有100个字段，那么对应的PO就有100个属性。
但是我们界面上只要显示10个字段，
客户端用WEB service来获取数据，没有必要把整个PO对象传递到客户端，
这时我们就可以用只有这10个属性的DTO来传递结果到客户端，这样也不会暴露服务端表结构.到达客户端以后，如果用这个对象来对应界面显示，那此时它的身份就转为VO

 

DAO
*****

data access object数据访问对象
这个大家最熟悉，和上面几个O区别最大，基本没有互相转化的可能性和必要.
主要用来封装对数据库的访问。通过它可以把POJO持久化为PO，用PO组装出来VO、DTO


**为什么不能直接用实体模型实现层与层传递？**

DTO（Data Tansfer Object）即数据传输对象。不明白有些框架中为什么要专门定义DTO来绑定表现层中的数据，为什么不能直接用实体模型实现层与层之间的数据传输，有了DTO同时还要维护DTO与Model之间的映射关系与转换？

表现层与应用层之间是通过数据传输对象（DTO）进行交互的，数据传输对象是没有行为的POJO对象，它 的目的只是为了对领域对象进行数据封装，实现层与层之间的数据传递。为何不能直接将领域对象用于 数据传递？因为领域对象更注重领域，而DTO更注重数据。不仅如此，由于“富领域模型”的特点，这样做会直接将领域对象的行为暴露给表现层。

需要了解的是，数据传输对象DTO本身并不是业务对象。数据传输对象是根据UI的需求进行设计的，而不 是根据领域对象进行设计的。比如，Customer领域对象可能会包含一些诸如FirstName, LastName, Email, Address等信息。但如果UI上不打算显示Address的信息，那么CustomerDTO中也无需包含这个Address的数据。

简单来说Model面向业务，我们是通过业务来定义Model的。而DTO是面向界面UI，是通过UI的需求来定义的。通过DTO我们实现了表现层与Model之间的解耦，表现层不引用Model，如果开发过程中我们的模型改变了，而界面没变，我们就只需要改Model而不需要去改表现层中的东西。


快速上手
==============
在线界面初始化项目
*******************
https://start.spring.io/

环境准备
*********

 ensure that you have valid versions of Java and Maven installed::

    $ java -version
    java version "1.8.0_102"
    Java(TM) SE Runtime Environment (build 1.8.0_102-b14)
    Java HotSpot(TM) 64-Bit Server VM (build 25.102-b14, mixed mode)

    $ mvn -v
    Apache Maven 3.5.4 (1edded0938998edf8bf061f1ceb3cfdeccf443fe; 2018-06-17T14:33:14-04:00)
    Maven home: /usr/local/Cellar/maven/3.3.9/libexec
    Java version: 1.8.0_102, vendor: Oracle Corporation


pom.xml
*********
Spring Boot provides a number of “Starters” that let you add jars to your classpath. The spring-boot-starter-parent is a special starter that provides useful Maven defaults. It also provides a dependency-management section so that you can omit version tags for “blessed” dependencies.

Other “Starters” provide dependencies that you are likely to need when developing a specific type of application. Since we are developing a web application, we add a spring-boot-starter-web dependency. Before that, we can look at what we currently have by running the following command::

    mvn dependency:tree

The mvn dependency:tree command prints a tree representation of your project dependencies. 

添加Code
*************
打开 Application.java 类，添加一个方法和一个annotation（代码高亮部分）:

.. code-block:: java
    :linenos:
    :emphasize-lines: 8,12-15

    package com.example.demo;

    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    @SpringBootApplication
    public class DemoApplication {

        @RequestMapping("/")
        String home() {
            return "Hello World!";
        }
        
        public static void main(String[] args) {
            SpringApplication.run(DemoApplication.class, args);
        }

    }


1. @RestController This annotation provides handling incoming web requests and return JSON response. 
2. @RequestMapping This annotation provides “routing” information. 
3. main方法 这只是遵循Java约定的应用程序入口点的标准方法。 我们的main方法通过调用run委托给Spring Boot的SpringApplication类。 SpringApplication会引导我们的应用程序，并启动Spring，后者反过来又会启动自动配置的Tomcat Web服务器。 

运行程序
*************
介绍2种方式运行程序。

IDE中执行
----------
导入到Eclipse中，然后直接运行DemoApplication类中的main方法。

mvn执行
----------
在POM文件种，程序依赖了spring-boot-starter-parent, you have a useful run goal that you can use to start the application::

    mvn spring-boot:run

打开浏览器，访问 http://localhost:8080, you should see the following output::

    Hello World!


创建 an Executable Jar
**********************************
通过创建可以在生产环境中运行的完全独立的可执行jar文件来结束示例。 可执行jar（有时称为“fat jar”）是包含已编译类以及代码需要运行的所有jar依赖项的归档文件。

运行命令::

    mvn package

If you look in the target directory, you should see demo-0.0.1-SNAPSHOT.jar. The file should be around 10 MB in size. If you want to peek inside, you can use jar tvf, as follows::

    jar tvf target/demo-0.0.1-SNAPSHOT.jar

You should also see a much smaller file named demo-0.0.1-SNAPSHOT.jar.original in the target directory. This is the original jar file that Maven created before it was repackaged by Spring Boot.

To run that application, use the java -jar command, as follows::

    java -jar target/demo-0.0.1-SNAPSHOT.jar


As before, to exit the application, press :guilabel:`&Ctrl` + :guilabel:`&c` 。

部署
**********
上述命令，一旦关闭命令框，程序将会终止，这时可以使用如下命令::

    nohup java -jar your_app.jar --server.port=8888 &



参考
==============================
https://docs.spring.io/spring-boot/docs/current/reference/html/getting-started.html#getting-started-first-application