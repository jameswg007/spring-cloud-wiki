############################
Spring Data JPA
############################

Spring Data JPA旨在通过减少实际需要的工作量来显著改善数据访问层的实现。 作为开发人员，仅需编写repository接口，包括自定义查找器方法，Spring将自动提供实现。

依赖
========

.. code-block:: xml
    :linenos:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>

创建和删除JPA数据库
==============================
默认情况下，仅当您使用嵌入式数据库（H2，HSQL或Derby）时，才会自动创建JPA数据库。您可以使用spring.jpa.*属性显式配置JPA设置。例如，要创建和删除表，可以将以下行添加到application.properties::

    spring.jpa.hibernate.ddl-auto=create-drop

值可以是这些：

* create：每次运行程序时，都会重新创建表，故而数据会丢失
* create-drop：每次运行程序时会先创建表结构，然后待程序结束时清空表
* upadte：每次运行程序，没有表时会创建表，如果对象发生改变会更新表结构，原有数据不会清空，只会更新（推荐使用）
* validate：运行程序会校验数据与数据库的字段类型是否相同，字段不同会报错
* none: 禁用DDL处理

Query Creation
=================

::

    public interface UserRepository extends Repository<User, Long> {
        List<User> findByEmailAddressAndLastname(String emailAddress, String lastname);
    }


https://docs.spring.io/spring-data/jpa/docs/2.2.0.RELEASE/reference/html/#jpa.query-methods.query-creation

Using @Query
=================
::

    public interface UserRepository extends JpaRepository<User, Long> {
    @Query("select u from User u where u.emailAddress = ?1")
    User findByEmailAddress(String emailAddress);
    }

https://docs.spring.io/spring-data/jpa/docs/2.2.0.RELEASE/reference/html/#jpa.query-methods.at-query

Using Named Parameters
==================================

::

    public interface UserRepository extends JpaRepository<User, Long> {

    @Query("select u from User u where u.firstname = :firstname or u.lastname = :lastname")
    User findByLastnameOrFirstname(@Param("lastname") String lastname,
                                    @Param("firstname") String firstname);
    }

Using SpEL Expressions
==================================

::

    @Entity
    public class User {

    @Id
    @GeneratedValue
    Long id;

    String lastname;
    }

    public interface UserRepository extends JpaRepository<User,Long> {

    @Query("select u from #{#entityName} u where u.lastname = ?1")
    List<User> findByLastname(String lastname);
    }

https://docs.spring.io/spring-data/jpa/docs/2.2.0.RELEASE/reference/html/#jpa.query.spel-expressions


Modifying Queries
==================================

::

    @Modifying
    @Query("update User u set u.firstname = ?1 where u.lastname = ?2")
    int setFixedFirstnameFor(String firstname, String lastname);


https://docs.spring.io/spring-data/jpa/docs/2.2.0.RELEASE/reference/html/#jpa.modifying-queries

Init
======
https://www.baeldung.com/running-setup-logic-on-startup-in-spring


参考
=========
https://docs.spring.io/spring-data/jpa/docs/2.2.0.RELEASE/reference/html/#reference