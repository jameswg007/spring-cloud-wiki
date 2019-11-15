########################
初识 Maven
########################


Maven介绍
==============================

.. list-table:: Maven Lifecycle 
   :widths: 5 10
   :header-rows: 1

   * - phases
     - description
   * - validate
     - validate the project is correct and all necessary information is available
   * - compile
     - compile the source code of the project
   * - test
     - test the compiled source code using a suitable unit testing framework. These tests should not require the code be packaged or deployed
   * - package
     - take the compiled code and package it in its distributable format, such as a JAR.
   * - verify
     - run any checks on results of integration tests to ensure quality criteria are met
   * - install
     - install the package into the local repository, for use as a dependency in other projects locally
   * - deploy
     - done in the build environment, copies the final package to the remote repository for sharing with other developers and projects


多线程
==============================
::

	mvn -T 4 clean install	# 用 4 个线程构建
	mvn -T 1C clean install	# 根据 CPU 核数每个核分配 1 个线程进行构建

跳过测试
==============================
::

	-DskipTests               # 不执行测试用例，但编译测试用例类生成相应的 class 文件至 target/test-classes 下
	-Dmaven.test.skip=true    # 不执行测试用例，也不编译测试用例类

编译失败后，接着编译
==============================
::

	mvn -rf :moduleName clean install 	# 通过指定之前失败的模块名，可以继续之前的编译

编译到最后再报错
====================================
::

	mvn clean install --fail-at-end		# 跳过失败的模块，编译到最后再报错

使用 Nexus 本地私服
==============================
使用 Aliyun 国内镜像
==============================
https://maven.aliyun.com/mvn/view

::

	<repositories>
		<repository>
			<id>spring-milestones</id>
			<name>Spring Milestones</name>
			<url>https://repo.spring.io/milestone</url>
		</repository>
	</repositories>

指定 Repository 目录
==============================
::

	<!-- Default: ~/.m2/repository  -->
	<localRepository>D:\apps\maven\repository</localRepository>

Maven Properties
==============================
::

	mvn clean install -Dmy.property=propertyValue

Maven Sources
==============================
	mvn dependency:sources


Maven Proxy
==============================
命令行设置
*************
::

	# Linux (bash)
	$ export MAVEN_OPTS="-DsocksProxyHost=10.10.10.10 -DsocksProxyPort=8080"
	# Windows
	$ set MAVEN_OPTS="-DsocksProxyHost=10.10.10.10 -DsocksProxyPort=8080"

配置文件
*************
::

	$ vim $MAVEN_HOME/conf/settings.xml
	<proxies>
		<proxy>
		<id>socks-proxy</id>
		<active>true</active>
		<protocol>socks5</protocol>
		<host>127.0.0.1</host>
		<port>1080</port>
		<nonProxyHosts>*.**.com</nonProxyHosts>
		</proxy>
	</proxies>


Dependency local Jar
=========================
.. code-block:: xml
	:linenos:
		
	<dependency>
		<groupId>com.sample</groupId>
		<artifactId>sample</artifactId>
		<version>1.0</version>
		<scope>system</scope>
		<systemPath>${project.basedir}/src/main/resources/yourJar.jar</systemPath>
	</dependency>

Install Jar
====================
.. code-block:: sh
	:linenos:

	mvn install:install-file -Dfile=RetainSDI.jar -DgroupId=com.ibm -DartifactId=retain -Dversion=1.0 -Dpackaging=jar -DgeneratePom=true
	mvn deploy:deploy-file -DgroupId=richinfo -DartifactId=logscommon -Dversion=0.0.1-SNAPSHOT -Dpackaging=jar -Dfile=/work/test/sftp_test/logscommon.jar -Durl=http://scm:scm12345@112.35.28.123:8815/nexus/content/repositories/snapshots -DrepositoryId=nexus -s settings.xml


MAVEN 属性
====================

内置属性
*************
如${basedir}表示项目根目录，${version}表示项目版本。

POM属性
*************

.. code-block:: xml
	:linenos:

	<project>
	<modelVersion>4.0.0</modelVersion>
	<groupId>org.sonatype.mavenbook</groupId>
	<artifactId>project-a</artifactId>
	<version>1.0-SNAPSHOT</version>
	<packaging>jar</packaging>
	<build>
		<finalName>${project.groupId}-${project.artifactId}</finalName>
	</build>
	</project>

可以使用点标记(.)的路径来引用POM元素的值::

	${basedir} 项目根目录
	${project.build.directory} 构建目录，缺省为target
	${project.build.outputDirectory} 构建过程输出目录，缺省为target/classes
	${project.build.finalName} 产出物名称，缺省为${project.artifactId}-${project.version}
	${project.packaging} 打包类型，缺省为jar
	${project.xxx} 当前pom文件的任意节点的内容

自定义属性属性
*****************
用户可以在pom的<properties>元素下自定义maven属性。

setting属性
*****************
用户可以使用以settings开头的属性引用settings.xml中xml元素的值，如${settings.localRepository}指向用户本地仓库的地址。

Java系统属性
*****************
maven可以使用当前java系统的属性，如${user.home}指向了用户目录。


环境变量属性
*************
env变量，暴露了你操作系统或者shell的环境变量。便 如在Maven POM中一个对${env.PATH}的引用将会被${PATH}环境变量替换，在Windows中为%PATH%。所有环境变量都可以使用以env.开头的属性。如：${env.JAVA_HOE}。

MAVEN_OPTS
====================
::

	MAVEN_OPTS:-Xmx1024m

Nexus Security
====================
问题描述：目前项目组的Artifact全部放在云仓库中，匿名用户也可以随时访问，存在很大的安全问题。
 
* 解决办法

  * 统一给仓库添加权限认证，阻止匿名用户访问。
  * 选择 Security -- Users -- anonymous -- config -- status -- Disabled
 
* 执行步骤

  * 使用项目组统一下发的settings.xml文件；
 
* 参考细节

  * 本地mvn命令加上参数“-s settings.xml”，（如果把settings文件替换mvn默认的全局文件的话，这个可以省略）;
  * wget命令1：wget –auth-no-challenge –http-user=admin –http-password=admin123 http:url
  * wget命令2：wget –auth-no-challenge –user=admin –password=admin123 http:url
  * curl命令：curl -u admin:admin123 http:url

Error in Eclipse
====================
1. Spring Boot 2.1.X 版本在 Eclipse showing “Maven Configuration Problem: Unknown”，我们需要在properties节点中加上maven-jar-plugin.version:

.. code-block:: xml
	:linenos:

	<properties>
		<java.version>1.8</java.version>
		<maven-jar-plugin.version>3.1.1</maven-jar-plugin.version>
	</properties>

参考
==============================
* https://www.baeldung.com/maven
* https://jazz.net/downloads/rational-team-concert/releases/6.0.6.1?p=allDownloads
* 下面shell脚本演示的是打印文件夹下文件名的例子:

 .. code-block:: sh
	:linenos:

	#!/bin/bash

	search_dir=/Users/murphy/Downloads/RTC-Client-plainJavaLib-6.0.6.1

	for entry in `ls $search_dir`; do
		# echo $entry
		if [ ${entry##*.} == "jar" ]
		then
		echo ${entry%.*}
		# pwd
		fi
	done

