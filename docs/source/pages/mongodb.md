##############################
Spring Boot MongoDB
##############################

开始使用MongoDB
====================

Maven依赖
=============

.. code-block:: xml
    :linenos:

    <parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>2.2.1.RELEASE</version>
		<relativePath/> <!-- lookup parent from repository -->
	</parent>

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-mongodb</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

CRUD
======

Entity
***********

.. code-block:: java
    :linenos:

    package com.example.mongodb.entity;

    import org.springframework.data.annotation.Id;
    import org.springframework.data.mongodb.core.mapping.Document;

    @Document
    public class Customer {

        @Id
        public String id;

        public String firstName;
        public String lastName;

        public Customer() {
        }

        public Customer(String firstName, String lastName) {
            this.firstName = firstName;
            this.lastName = lastName;
        }

        @Override
        public String toString() {
            return String.format("Customer[id=%s, firstName='%s', lastName='%s']", id, firstName, lastName);
        }

    }

Repository
*****************
.. code-block:: java
    :linenos:

    package com.example.mongodb.repository;

    import java.util.List;

    import org.springframework.data.mongodb.repository.MongoRepository;
    import org.springframework.stereotype.Repository;

    import com.example.mongodb.entity.Customer;

    @Repository
    public interface CustomerRepository extends MongoRepository<Customer, String> {

    public Customer findByFirstName(String firstName);
    public List<Customer> findByLastName(String lastName);

    }



Service
***********
.. code-block:: java
    :linenos:

    package com.example.mongodb.service;

    import java.util.List;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Service;

    import com.example.mongodb.entity.Customer;
    import com.example.mongodb.repository.CustomerRepository;

    @Service
    public class CustomerService {

        @Autowired
        private CustomerRepository customerRepository;

        public List<Customer> getCustomers() {
            customerRepository.deleteAll();

            // save a couple of customers
            customerRepository.save(new Customer("Alice", "Smith"));
            customerRepository.save(new Customer("Bob", "Smith"));

            // fetch all customers
            System.out.println("Customers found with findAll():");
            System.out.println("-------------------------------");
            List<Customer> customers = customerRepository.findAll();
            for (Customer customer : customers) {
                System.out.println(customer);
            }
            System.out.println();

            // fetch an individual customer
            System.out.println("Customer found with findByFirstName('Alice'):");
            System.out.println("--------------------------------");
            System.out.println(customerRepository.findByFirstName("Alice"));

            System.out.println("Customers found with findByLastName('Smith'):");
            System.out.println("--------------------------------");
            for (Customer customer : customerRepository.findByLastName("Smith")) {
                System.out.println(customer);
            }
            return customers;

        }

    }

RestController
***********************

.. code-block:: java
    :linenos:

    package com.example.mongodb.controller;

    import java.util.List;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.http.ResponseEntity;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.RestController;

    import com.example.mongodb.entity.Customer;
    import com.example.mongodb.service.CustomerService;

    @RestController
    public class CustomerController {

        @Autowired
        private CustomerService customerService;

        @GetMapping("/customer")
        public ResponseEntity<List<Customer>> getCustomer(String name) {
            return ResponseEntity.ok(customerService.getCustomers());
        }
    }



application.properties
*********************************
::

    spring.data.mongodb.username=root_app
    spring.data.mongodb.password=root123
    spring.data.mongodb.database=mymongo
    spring.data.mongodb.port=27017
    spring.data.mongodb.host=localhost


Mongodb
************

1. 访问：http://localhost:8080/customer ， 显示如下::

    [{"id":"5de08e14afacb903cc733ac9","firstName":"Alice","lastName":"Smith"},
    {"id":"5de08e14afacb903cc733aca","firstName":"Bob","lastName":"Smith"}]

2. Mongodb客户端：

.. image:: images/mongodb.png
   :alt: alternate text



参考
========
https://spring.io/guides/gs/accessing-data-mongodb/