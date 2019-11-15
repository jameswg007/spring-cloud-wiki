################################################
Spring Boot Service
################################################

理解 Service
==============================
Service Components are the class file which contains @Service annotation. These class files are used to write business logic in a different layer.

@Autowired
=============
Inject list of all beans with a certain interface

.. code-block:: java
    :linenos:

    @Component
    public class SomeComponent {

        interface SomeInterface {

        }

        @Component
        class Impl1 implements SomeInterface {

        }

        @Component
        class Impl2 implements SomeInterface {

        }

        @Autowired
        private List<SomeInterface> listOfImpls;
    }


类中获取属性数据
==============================

@ConfigurationProperties
********************************

.. code-block:: java
    :linenos:

    @PropertySource("classpath:dbconfig.properties")
    @ConfigurationProperties("database")
    public class DatabaseConfiguration {
        
        @Length(min=2, max=10)
        private String name;
        
        @NotEmpty
        private String url;
        
        @Length(min=5, max=10)
        @Pattern(regexp = "[a-z-A-Z]*", message = "Username can not contain invalid characters") 
        private String username;

        @Length(min=8, max=16)
        private String password;

    }

* @PropertySource 标签是指定属性文件，默认是application.yml 或 application.properties
* @ConfigurationProperties 标签指定属性文件中的属性前缀

@Value
********************************
This annotation can be used for injecting values into fields in Spring-managed beans and it can be applied at the field or constructor/method parameter level.

https://www.baeldung.com/spring-value-annotation

Error Handling for REST
==============================
::

    @ResponseStatus(code = HttpStatus.NOT_FOUND, reason = "Actor Not Found")
    public class ActorNotFoundException extends Exception {
    }

    @GetMapping("/actor/{id}")
    public String getActorName(@PathVariable("id") int id) {
        try {
            return actorService.getActor(id);
        } catch (ActorNotFoundException ex) {
            throw new ResponseStatusException(
              HttpStatus.NOT_FOUND, "Actor Not Found", ex);
        }
    }


* https://www.baeldung.com/exception-handling-for-rest-with-spring
* https://www.baeldung.com/spring-response-status-exception
* https://www.mkyong.com/spring-boot/spring-rest-error-handling-example/

Spring boot自定义注解
==============================

.. code-block:: sql
    :linenos:

    <!-- AOP依赖模块 -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-aop</artifactId>
    </dependency>

使用自定义注解来统计方法的执行时间
**********************************
创建@AnalysisActuator
---------------------------

.. code-block:: java
    :linenos:

    package com.example.demo.aop;

    import java.lang.annotation.ElementType;
    import java.lang.annotation.Retention;
    import java.lang.annotation.RetentionPolicy;
    import java.lang.annotation.Target;

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    public @interface AnalysisActuator {
        String note() default "";
    }

创建Aspect
---------------------------

.. code-block:: java
    :linenos:

    package com.example.demo.aop;

    import org.aspectj.lang.JoinPoint;
    import org.aspectj.lang.annotation.After;
    import org.aspectj.lang.annotation.Aspect;
    import org.aspectj.lang.annotation.Before;
    import org.aspectj.lang.annotation.Pointcut;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    import org.springframework.core.annotation.Order;
    import org.springframework.stereotype.Component;

    @Aspect
    @Component
    public class AnalysisActuatorAspect {
        final static Logger log = LoggerFactory.getLogger(AnalysisActuatorAspect.class);

        ThreadLocal<Long> beginTime = new ThreadLocal<>();

        @Pointcut("@annotation(analysisActuator)")
        public void serviceStatistics(AnalysisActuator analysisActuator) {
        }

        @Before("serviceStatistics(analysisActuator)")
        public void doBefore(JoinPoint joinPoint, AnalysisActuator analysisActuator) {
            // 记录请求到达时间
            beginTime.set(System.currentTimeMillis());
            log.info("------ note:{}", analysisActuator.note());
        }

        @After("serviceStatistics(analysisActuator)")
        public void doAfter(AnalysisActuator analysisActuator) {
            log.info("------ statistic time:{}, note:{}", System.currentTimeMillis() - beginTime.get(),
                    analysisActuator.note());
        }

    }

使用
--------

.. code-block:: java
    :linenos:

    package com.example.demo.controller;

    import java.util.Optional;

    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.RestController;

    import com.example.demo.aop.AnalysisActuator;

    @RestController
    public class HelloWorldController {

        @GetMapping("/")
        @AnalysisActuator(note = "HelloWorldController中的hello方法")
        public String hello(String name) {
            return "Hello " + Optional.ofNullable(name).orElse("World!");
        }
    }

调用地址：http://localhost:8080/?name=Java 屏幕打印：

::

    2019-10-22 15:21:18.512  INFO 22521 --- [nio-8080-exec-1] c.e.demo.aop.AnalysisActuatorAspect
          : ------ note:HelloWorldController中的hello方法
    2019-10-22 15:21:18.550  INFO 22521 --- [nio-8080-exec-1] c.e.demo.aop.AnalysisActuatorAspect
          : ------ statistic time:38, note:HelloWorldController中的hello方法

