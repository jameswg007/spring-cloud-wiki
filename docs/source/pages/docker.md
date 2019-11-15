########################
初识 Docker
########################


介绍
==========

Install
====================

Centos
*********
https://docs.docker.com/install/linux/docker-ce/centos/

Install Docker Compose
***************************
https://docs.docker.com/compose/install/


image and compose
====================

Dockerfile

.. code-block:: docker
    :linenos:

    FROM openjdk:8-jdk-alpine
    VOLUME /tmp
    ARG JAR_FILE
    COPY ${JAR_FILE} app.jar
    ENTRYPOINT ["java","-jar","/app.jar"]


::

    docker build –build-arg JAR_FILE=target/springbootjar-0.0.1-SNAPSHOT.jar -t image_name .
    docker run -d –name container_name -p 9100:8080 image_name

.. note:: -p <host_port>:<container_port>

command
=============
::

    docker build -t murphylan/cod_wiki .
    docker push murphylan/cod_wiki
    docker run -d --name mshop -p 80:80 murphylan/cod_mshop
    docker run -d --name wiki -p 8082:80 murphylan/cod_wiki
    docker ps                                          # List all running containers
    docker container ls                                # List all running containers
    docker container ls -a             # List all containers, even those not running
    docker container stop <hash>           # Gracefully stop the specified container
    docker container kill <hash>         # Force shutdown of the specified container
    docker container rm <hash>        # Remove specified container from this machine
    docker container rm $(docker container ls -a -q)         # Remove all containers
    docker image ls -a                             # List all images on this machine
    docker image rm <image id>            # Remove specified image from this machine
    docker image rm $(docker image ls -a -q)   # Remove all images from this machine
    docker login             # Log in this CLI session using your Docker credentials
    docker tag <image> username/repository:tag  # Tag <image> for upload to registry
    docker push username/repository:tag            # Upload tagged image to registry
    docker run username/repository:tag                   # Run image from a registry

    docker stack ls                                            # List stacks or apps
    docker stack deploy -c <composefile> <appname>  # Run the specified Compose file
    docker service ls                 # List running services associated with an app
    docker service ps <service>                  # List tasks associated with an app
    docker inspect <task or container>                   # Inspect task or container
    docker container ls -q                                      # List container IDs
    docker stack rm <appname>                             # Tear down an application
    docker swarm leave --force      # Take down a single node swarm from the manager
    docker logs <container_id>      # 显示日志

搭建 DB server
====================
https://github.ibm.com/lanzejun/db-docker

docker-compose.yml
**********************

.. code-block:: yaml
    :linenos:

    version: '3'
    services:
    mysql-server:
        container_name: mysql-server
        image: mysql:5.7
        volumes:
        - ./mysqldb:/var/lib/mysql
        environment:
            MYSQL_ROOT_PASSWORD: mysql123
            MYSQL_DATABASE: my_db
            MYSQL_USER: root
        ports:
        - 3306:3306
        expose:
        - 3306
    mongo-server:
        container_name: mongo-server
        image: mongo:4.0.8-xenial
        environment:
            MONGO_INITDB_ROOT_USERNAME: root_app
            MONGO_INITDB_ROOT_PASSWORD: root123
            MONGO_DATABASE: mymongo
        volumes:
        - ./mongo-init.sh:/docker-entrypoint-initdb.d/mongo-init.sh:ro
        - ./mongodb/data/db:/data/db
        ports:
        - 27017:27017
        expose:
        - 27017
    redis:
        image: 'bitnami/redis:5.0'
        environment:
            # ALLOW_EMPTY_PASSWORD is recommended only for development.
            - ALLOW_EMPTY_PASSWORD=yes
            - REDIS_DISABLE_COMMANDS=FLUSHDB,FLUSHALL
        ports:
            - '6379:6379'
        volumes:
            - ./redisdb:/bitnami/redis/data
    rabbitmq:
        image: rabbitmq:management
        container_name: rabbitmq
        command: rabbitmq-server
        ports:
        - 15672:15672
        - 5672:5672
        expose:
        - 5672
        - 15672

mongo-init.sh
**********************

.. code-block:: sh
    :linenos:

    mongo -- "$MONGO_DATABASE" <<EOF
        var user = '$MONGO_INITDB_ROOT_USERNAME';
        var passwd = '$MONGO_INITDB_ROOT_PASSWORD';
        var admin = db.getSiblingDB('admin');
        admin.auth(user, passwd);
        db.createUser({user: user, pwd: passwd, roles: ["readWrite"]});
    EOF

start.sh
**********************

.. code-block:: sh
    :linenos:
    
    #!/bin/bash

    echo "Stop and clean all container ..."
    docker container rm $(docker container ls -a -q)  -f
    docker-compose rm -v

    # echo "Clean all images with sba tag ..."
    # docker rmi $(docker images | grep sba | tr -s ' ' | cut -d ' ' -f 3)

    echo "docker-compose build and up ..."
    docker-compose build
    docker-compose up -d



Issue
=========
* Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?

    ::

        systemctl start docker

* ERROR: for user-auth no such image

    ::
    
        docker-compose rm -v

* Delete old Docker images to free up space::

    # remove all unused / orphaned images
    echo -e  "Removing unused images..."
    docker rmi -f $(docker images --no-trunc | grep "<none>" | awk "{print \$3}") 2>&1 | cat;
    echo -e  "Done removing unused images"

    # clean up stuff -> using these instructions https://lebkowski.name/docker-volumes/
    echo -e  "Cleaning up old containers..."
    docker ps --filter status=dead --filter status=exited -aq | xargs docker rm -v 2>&1 | cat;
    echo -e  "Cleaning up old volumes..."
    docker volume ls -qf dangling=true | xargs docker volume rm 2>&1 | cat;

* start redis error:

.. code-block:: sh
    :linenos:
    :emphasize-lines: 10,11

    05:50:03.00 INFO  ==> ** Starting Redis setup **
    05:50:03.01 WARN  ==> You set the environment variable ALLOW_EMPTY_PASSWORD=yes. For safety reasons, do not use this flag in a production environment.
    05:50:03.01 INFO  ==> Initializing Redis...

    05:50:03.08 INFO  ==> ** Redis setup finished! **
    05:50:03.09 INFO  ==> ** Starting Redis **
    1:C 01 Nov 2019 05:50:03.107 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
    1:C 01 Nov 2019 05:50:03.107 # Redis version=5.0.5, bits=64, commit=00000000, modified=0, pid=1, just started
    1:C 01 Nov 2019 05:50:03.107 # Configuration loaded
    1:M 01 Nov 2019 05:50:03.108 # Can't open the append-only file: Permission denied
    [root@buildup1 db-docker]# sudo chown -R 1001:1001 redisdb/
