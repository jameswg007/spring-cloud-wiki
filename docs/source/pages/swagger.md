########################
Springfox-Swagger2
########################

Maven Dependency
==============================

.. code-block:: xml
    :linenos:

    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger2</artifactId>
        <version>2.9.2</version>
    </dependency>
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger-ui</artifactId>
        <version>2.9.2</version>
    </dependency>


Configuration
==============================

.. code-block:: java
    :linenos:

    @Configuration
    @EnableSwagger2
    public class SwaggerConfig {                                    
        @Bean
        public Docket api() { 
            return new Docket(DocumentationType.SWAGGER_2)  
            .select()                                  
            .apis(RequestHandlerSelectors.any())              
            .paths(PathSelectors.any())                          
            .build();                                           
        }
    }

Verification
==============================
* http://localhost:8080/swagger-ui.html
* http://localhost:8080/v2/api-docs


参考
========
https://www.baeldung.com/swagger-2-documentation-for-spring-rest-api