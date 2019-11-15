################################################
Spring Boot Controller
################################################

理解 Controller
==============================
@Controller vs @RestController

::

    @RestController = @Controller + @ResponseBody

实现REST服务
==============================
.. code-block:: java
    :linenos:

    @RestController
    public class HelloWorldController {
        @Autowired
        private IHelloWorldService helloWorldService;

        @GetMapping("/hello")
        public String hello(String name) {
            return helloWorldService.getHelloMessage(name);
        }
    }

    @Service
    public class HelloWorldServiceImpl implements IHelloWorldService {

        public String getHelloMessage(String name) {
            return "Hello " + Optional.ofNullable(name).orElse("World!");
        }

    }

ResponseEntity
=================
https://www.baeldung.com/spring-response-entity

.. code-block:: java
    :linenos:

    @GetMapping("/hello")
    ResponseEntity<String> hello() {
        return ResponseEntity.ok("Hello World!");
    }

RequestMapping
=====================
RequestMapping route 有多种方式。

.. code-block:: java
    :linenos:

    package com.example.demo.controller;

    import org.springframework.http.ResponseEntity;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    public class HelloController {

        @GetMapping("/hello")
        ResponseEntity<String> hello() {
            return ResponseEntity.ok("Hello World!");
        }

        @GetMapping({ "/hello2", "hello3" })
        ResponseEntity<String> hello2() {
            return ResponseEntity.ok("Hello World!");
        }

        @GetMapping(value = "/hello3", headers = "key=val")
        ResponseEntity<String> hello3() {
            return ResponseEntity.ok("Hello World!");
        }

        @GetMapping(value = "/hello4", headers = { "key1=val1", "key2=val2" })
        ResponseEntity<String> hello4() {
            return ResponseEntity.ok("Hello World!");
        }

        @GetMapping(value = "/hello5", headers = "Accept=application/json")
        ResponseEntity<String> hello5() {
            return ResponseEntity.ok("Hello World!");
        }

        @GetMapping(value = "/hello6", produces = "application/json")
        String hello6() {
            return "Hello World!";
        }

    }

测试

.. code-block:: sh
    :linenos:

    curl -i http://localhost:8080/hello
    curl -i -H "key:val" http://localhost:8080/hello3
    curl -i -H "key1:val1" -H "key2:val2" http://localhost:8080/hello4
    curl -H "Accept:application/json,text/html" http://localhost:8080/hello5

Controller中获取参数
==============================

Controller方法的形参
***********************************
直接把表单的参数写在Controller相应的方法的形参中，适用于get方式提交，不适用于post方式提交。

.. code-block:: java
    :linenos:

    /**
    * 1.直接把表单的参数写在Controller相应的方法的形参中
    * @param username
    * @param password
    * @return
    */
    @RequestMapping("/addUser1")
    public String addUser1(String username,String password) {
        System.out.println("username is:"+username);
        System.out.println("password is:"+password);
        return "demo/index";
    }

url形式：http://localhost/demo/addUser1?username=training&password=111111 提交的参数需要和Controller方法中的入参名称一致。


HttpServletRequest
***********************************
通过HttpServletRequest接收，post方式和get方式都可以。

.. code-block:: java
    :linenos:

    /**
    * 2、通过HttpServletRequest接收
    * @param request
    * @return
    */
    @RequestMapping("/addUser2")
    public String addUser2(HttpServletRequest request) {
        String username=request.getParameter("username");
        String password=request.getParameter("password");
        System.out.println("username is:"+username);
        System.out.println("password is:"+password);
        return "demo/index";
    }


通过Bean接收
***********************************
通过一个bean来接收,post方式和get方式都可以。

.. code-block:: java
    :linenos:

    /**
    * 3、通过一个bean来接收
    * @param user
    * @return
    */
    @RequestMapping("/addUser3")
    public String addUser3(UserModel user) {
        System.out.println("username is:"+user.getUsername());
        System.out.println("password is:"+user.getPassword());
        return "demo/index";
    }



@PathVariable
***********************************
通过@PathVariable获取路径中的参数

.. code-block:: java
    :linenos:

    @RestController
    @RequestMapping(value="/users")
    public class MyRestController {

        @RequestMapping(value="/{user}", method=RequestMethod.GET)
        public User getUser(@PathVariable Long user) {
            // ...
        }

        @RequestMapping(value="/{user}/customers", method=RequestMethod.GET)
        List<Customer> getUserCustomers(@PathVariable Long user) {
            // ...
        }

        @RequestMapping(value="/{user}", method=RequestMethod.DELETE)
        public User deleteUser(@PathVariable Long user) {
            // ...
        }

    }


@ModelAttribute
***********************************
使用@ModelAttribute注解获取POST请求的FORM表单数据

.. code-block:: jsp
    :linenos:

    <!--jsp页面--> 
    <form action ="<%=request.getContextPath()%>/demo/addUser5" method="post"> 
        用户名:<input type="text" name="username"/><br/> 
        密码:<input type="password" name="password"/><br/> 
        <input type="submit" value="提交"/> <input type="reset" value="重置"/> 
    </form> 

.. code-block:: java
    :linenos:

    /**
    * 5、使用@ModelAttribute注解获取POST请求的FORM表单数据
    * @param user
    * @return
    */
    @RequestMapping(value="/addUser5",method=RequestMethod.POST)
    public String addUser5(@ModelAttribute("user") UserModel user) {
        System.out.println("username is:"+user.getUsername());
        System.out.println("password is:"+user.getPassword());
        return "demo/index";
    }

@RequestParam
***********************************

用注解@RequestParam绑定请求参数到方法入参

.. code-block:: java
    :linenos:

    @GetMapping("/demo/{id}")
    public void demo(@PathVariable(name = "id") String id, @RequestParam(name = "name") String name) {
        System.out.println("id="+id);
        System.out.println("name="+name);
    }

当请求参数username不存在时会有异常发生,可以通过设置属性required=false解决,例如: @RequestParam(value="username", required=false)

@RequestBody
***********************************

.. code-block:: java
    :linenos:

    @PostMapping(path = "/demo1")
    public void demo1(@RequestBody Person person) {
        System.out.println(person.toString());
    }

前端JSON传值，@RequestBody 也可以省略

@RequestHeader @CookieValue
***********************************


.. code-block:: java
    :linenos:

    @GetMapping("/demo3")
    public void demo3(@RequestHeader(name = "myHeader") String myHeader,
            @CookieValue(name = "myCookie") String myCookie) {
        System.out.println("myHeader=" + myHeader);
        System.out.println("myCookie=" + myCookie);
    }

    /**
    * 8、上面的代码等同下面的代码
    */
    @GetMapping("/demo3")
    public void demo3(HttpServletRequest request) {
        System.out.println(request.getHeader("myHeader"));
        for (Cookie cookie : request.getCookies()) {
            if ("myCookie".equals(cookie.getName())) {
                System.out.println(cookie.getValue());
            }
        }
    }
