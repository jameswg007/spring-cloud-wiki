########################
Spring Boot Redis
########################

开始使用Redis
====================

Maven依赖
=============

.. code-block:: xml
    :linenos:

    <dependency>
        <groupId>org.springframework.data</groupId>
        <artifactId>spring-data-redis</artifactId>
        <version>2.0.3.RELEASE</version>
    </dependency>
    
    <dependency>
        <groupId>redis.clients</groupId>
        <artifactId>jedis</artifactId>
        <version>2.9.0</version>
        <type>jar</type>
    </dependency>

Configuration
========================

.. code-block:: java
    :linenos:

    @Bean
    JedisConnectionFactory jedisConnectionFactory() {
        JedisConnectionFactory jedisConFactory
        = new JedisConnectionFactory();
        jedisConFactory.setHostName("localhost");
        jedisConFactory.setPort(6379);
        return jedisConFactory;
    }
    
    @Bean
    public RedisTemplate<String, Object> redisTemplate() {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(jedisConnectionFactory());
        return template;
    }

Demo
========
pom
*******
.. code-block:: xml
    :linenos:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
    </dependency>

entity
***********
.. code-block:: java
    :linenos:

    package com.example.redis.entity;

    public class User {

        private String id;
        private String name;
        private long followers;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public long getFollowers() {
            return followers;
        }

        public void setFollowers(long followers) {
            this.followers = followers;
        }

        @Override
        public String toString() {
            return "User [id=" + id + ", name=" + name + ", followers=" + followers + "]";
        }

    }


repository
**********************
.. code-block:: java
    :linenos:

    package com.example.redis.repository;

    import java.util.Map;

    import javax.annotation.PostConstruct;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.data.redis.connection.lettuce.LettuceConnectionFactory;
    import org.springframework.data.redis.core.HashOperations;
    import org.springframework.data.redis.core.StringRedisTemplate;
    import org.springframework.stereotype.Repository;

    import com.example.redis.entity.User;

    @Repository
    public class UserRepository {

        @Autowired
        private StringRedisTemplate stringRedisTemplate;

        private HashOperations<String, Object, Object> hashOperations;

        @PostConstruct
        private void init() {
            hashOperations = stringRedisTemplate.opsForHash();
        }

        public void setDatabase(int index) {
            LettuceConnectionFactory lettuceConnectionFactory = (LettuceConnectionFactory) stringRedisTemplate
                    .getConnectionFactory();
            lettuceConnectionFactory.getStandaloneConfiguration().setDatabase(index);
            stringRedisTemplate.setConnectionFactory(lettuceConnectionFactory);
        }

        public void save(User user) {
            setDatabase(0);
            hashOperations.put("USER", user.getId(), user.toString());
        }

        public void delete(String id) {
            hashOperations.delete("USER", id);
        }

        public Map getUsers() {
            return hashOperations.entries("USER");
        }

    }


controller
**********************
.. code-block:: java
    :linenos:

    package com.example.redis.controller;

    import java.time.LocalTime;
    import java.util.Map;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.http.ResponseEntity;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.RestController;

    import com.example.redis.entity.User;
    import com.example.redis.repository.UserRepository;

    @RestController
    public class HelloWorldController {
        @Autowired
        private UserRepository userRepository;

        @GetMapping("/")
        public ResponseEntity<Map> hello(String name) {
            User user = new User();
            user.setId(LocalTime.now().toString());
            user.setName("Murphy");
            user.setFollowers(33);
            userRepository.save(user);

            return ResponseEntity.ok(userRepository.getUsers());
        }
    }


application.properties
*********************************
::

    spring.redis.host=127.0.0.1
    spring.redis.port=6379


参考
=======
https://www.baeldung.com/spring-data-redis-tutorial