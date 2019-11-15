########################
Assignment
########################

Maven
==========

练习的目标
---------------
1. 掌握在线构建 spring boot 项目
2. 掌握 maven 环境，仓库知识
3. 掌握 maven 依赖关系
4. 掌握 maven 执行周期
5. 掌握 git 使用方法
6. 掌握 spring boot 项目的基本功能

练习的要求
---------------
1. Create a parent project with 3 submodules.
 	This app will consist of three modules, that will represent:

	1. The core part of our domain
	2. A web service providing some information from accessing RTC(IBM Rational Team Concert) 
	3. A webapp containing user-facing web assets of some sort

 	Parent's pom.xml file:

	.. code-block:: xml
		:linenos:

		<modules>
			<module>core</module>
			<module>service</module>
			<module>webapp</module>
		</modules>

2. Building the Project:
	1. At least 1 unit test in each module.
	2. Run "mvn package" successful.

3. Deploy the Project:
	There is an area for displaying RTC information in webapp.

4. Commit your assignment into github with .gitignore.

.. note:: 注意2点 1. 子moudle里面不能有package plugin; 2. web里面的application的包路径需要在所有子module的包的父级

CRUD
========================================
CRUD(Create Read Update Delete)

练习的目标
---------------
掌握Spring Boot 项目基本的CRUD操作


练习的要求
---------------
1. 搭建Spring Boot项目开发环境，添加依赖（Web Thymeleaf JPA H2）

2. 实现进度表记录的展示、添加、修改和删除

	1. 修改默认端口
	2. 使用@Value标签，页面显示项目名称
	3. 创建Entity（进度表），持久化到H2数据库，项目启动时，初始化数据
	4. 自定义错误页面
	5. 界面使用Bootstrap(可选)

3. Commit your assignment into github with .gitignore.

4. 部署到阿里云(可选任何私有云)

参考：
https://www.baeldung.com/spring-boot-start