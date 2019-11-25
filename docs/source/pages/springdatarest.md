############################
Spring Data REST
############################

概要
==============================
本文将解释Spring Data REST的基础知识，并展示如何使用它来构建简单的REST API。
通常，Spring Data REST是在Spring Data项目的基础上构建的，可轻松构建连接到Spring Data存储库的hypermedia-driven的REST Web服务-所有这些都使用HAL作为驱动超媒体类型。

它减少了通常与此类任务相关的大量手动工作，并使Web应用程序的基本CRUD功能实现变得非常简单。

在本文中，我们将研究如何在Spring Data REST中处理实体之间的关系。 我们将重点研究Spring Data REST为存储库提供的关联资源，同时考虑可以定义的每种关系类型。 为了避免任何额外的设置，我们将使用H2嵌入式数据库作为示例。

Maven依赖
=============

.. code-block:: xml
    :linenos:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-rest</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>com.h2database</groupId>
        <artifactId>h2</artifactId>
    </dependency>


Demo
===========

1. 创建Entity

.. code-block:: java
    :linenos:

    package com.example.rest.entity;

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;

    @Entity
    public class WebsiteUser {

        @Id
        @GeneratedValue(strategy = GenerationType.AUTO)
        private long id;

        private String name;
        private String email;

        // standard getters and setters

    }

2. 创建Entity

.. code-block:: java
    :linenos:

    package com.example.rest.repository;

    import java.util.List;

    import org.springframework.data.repository.PagingAndSortingRepository;
    import org.springframework.data.repository.query.Param;
    import org.springframework.data.rest.core.annotation.RepositoryRestResource;

    import com.example.rest.entity.WebsiteUser;

    @RepositoryRestResource(collectionResourceRel = "users", path = "users")
    public interface UserRepository extends PagingAndSortingRepository<WebsiteUser, Long> {
        List<WebsiteUser> findByName(@Param("name") String name);
    }

3. 增加user

.. code-block:: sh
    :linenos:

    curl -i -X POST -H "Content-Type:application/json" -d '{  "name" : "Test", "email" : "test@test.com" }' http://localhost:8080/users



4. 访问 http://localhost:8080/users/1

.. code-block:: ActionScript
    :linenos:

    {
        "name": "Test",
        "email": "test@test.com",
        "_links": {
        "self": {
            "href": "http://localhost:8080/users/1"
            },
        "websiteUser": {
            "href": "http://localhost:8080/users/1"
            }
        }
    }

5. 查询 http://localhost:8080/users/search/findByName?name=Test


参考
=======
* https://www.baeldung.com/spring-data-rest-intro
* https://www.baeldung.com/spring-data-rest-relationships