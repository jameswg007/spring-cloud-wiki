############################
Spring Data REST
############################

概要
==============================
本文将解释Spring Data REST的基础知识，并展示如何使用它来构建简单的REST API。
通常，Spring Data REST是在Spring Data项目的基础上构建的，可轻松构建连接到Spring Data存储库的hypermedia-driven的REST Web服务-所有这些都使用HAL作为驱动超媒体类型。

它减少了通常与此类任务相关的大量手动工作，并使Web应用程序的基本CRUD功能实现变得非常简单。

在本文中，我们将研究如何在Spring Data REST中处理实体之间的关系。 我们将重点研究Spring Data REST为存储库提供的关联资源，同时考虑可以定义的每种关系类型。 为了避免任何额外的设置，我们将使用H2嵌入式数据库作为示例。

参考
=======
* https://www.baeldung.com/spring-data-rest-intro
* https://www.baeldung.com/spring-data-rest-relationships