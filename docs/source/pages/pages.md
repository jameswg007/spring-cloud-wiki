################################################
Spring Boot Pages
################################################

理解 Pages
==============================


模板引擎
==============================

Jsp
*********

https://www.baeldung.com/spring-template-engines

.. code-block:: ActionScript
    :linenos:

    spring.mvc.view.prefix: /WEB-INF/views/
    spring.mvc.view.suffix: .jsp


FreeMarker
****************
https://freemarker.apache.org/
https://hellokoding.com/spring-boot-hello-world-example-with-freemarker/

Groovy
****************

https://www.baeldung.com/spring-template-engines

Thymeleaf
****************
https://www.thymeleaf.org/
https://www.baeldung.com/spring-boot-crud-thymeleaf



页面获取数据
==============================

Model, ModelMap, and ModelAndView are used to define a model in a Spring MVC application. 

* Model defines a holder for model attributes and is primarily designed for adding attributes to the model. 
* ModelMap is an extension of Model with the ability to store attributes in a map and chain method calls. 
* ModelAndView is a holder for a model and a view; it allows to return both model and view in one return value.

Model
**********

.. code-block:: java
    :linenos:

    @GetMapping("/")
    public String homePage(Model model) {
        model.addAttribute("appName", appName);
        return "home";
    }

页面上::

    <span th:text="${appName}">Our App</span>

ModelMap
*************

.. code-block:: java
    :linenos:

    @GetMapping("/getMessageAndTime")
    public String getMessageAndTime(ModelMap map) {

        var ldt = LocalDateTime.now();

        var fmt = DateTimeFormatter.ofLocalizedDateTime(
                FormatStyle.MEDIUM);

        fmt.withLocale(new Locale("sk", "SK"));
        fmt.withZone(ZoneId.of("CET"));

        var time = fmt.format(ldt);

        map.addAttribute("message", message).addAttribute("time", time);

        return "show";
    }

ModelAndView
*******************

.. code-block:: java
    :linenos:

    @GetMapping("/getMessage2")
    public ModelAndView getMessage() {

        var mav = new ModelAndView();

        mav.addObject("message", message);
        mav.setViewName("show");

        return mav;
    }

@ModelAttribute
********************

.. code-block:: java
    :linenos:

    @ModelAttribute("motd")
    public String message() {

        return messageService.getMessage();
    }


webjars
=============
* https://www.webjars.org
* https://www.baeldung.com/maven-webjars