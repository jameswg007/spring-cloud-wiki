########################
Spring Boot CLI
########################

The Spring Boot CLI is a command line tool that you can use if you want to quickly develop a Spring application. 

安装Spring Boot CLI
==============================

从安装文件中手动安装
*********************************
1. 下载安装文件包 <https://repo.spring.io/release/org/springframework/boot/spring-boot-cli/2.2.0.RELEASE/spring-boot-cli-2.2.0.RELEASE-bin.zip>
2. 下载完成后，请按照解压缩后的存档中的INSTALL.txt说明进行操作。 

使用SDKMAN!安装
*********************************
命令如下::

    $ sdk install springboot
    $ spring --version
    Spring Boot v2.2.0.RELEASE

利用OSX Homebrew安装
*********************************
命令如下::

    $ brew tap pivotal/tap
    $ brew install springboot


使用MacPorts安装
*********************************
命令如下::

    sudo port install spring-boot-cli

开始使用CLI
==============================
To verify the install, run the command::

    spring --version

1. 创建文件 app.groovy::

    @RestController
    class ThisWillActuallyRun {

        @RequestMapping("/")
        String home() {
            "Hello World!"
        }

    }

2. 然后从CLI运行它，如下所示::

    spring run app.groovy


使用CLI初始化项目
==============================
::

    $ spring init --dependencies=web,data-jpa my-project
    Using service at https://start.spring.io
    Project extracted to '/Users/developer/example/my-project'

参考
=========
* https://docs.spring.io/spring-boot/docs/current/reference/html/spring-boot-cli.html
* https://docs.spring.io/spring-boot/docs/current/reference/html/getting-started.html#getting-started-installing-the-cli