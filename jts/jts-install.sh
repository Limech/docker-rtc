#!/bin/bash

## Run RTC
mkdir /tmp/dockmount

## Ensure latest runtime parameters are copied to the docker share
cp repotools-params /tmp/dockmount
cp basicUserRegistry.xml /tmp/dockmount
cp ldapUserRegistry.xml /tmp/dockmount

docker build --rm -t jts-build .

docker run -it --name myjts -p 9080:9080 -p 9443:9443 -v /tmp/dockmount:/tmp/dockmount --net=host jts-build /opt/IBM/JazzTeamServer/server/repotools-install.sh

docker commit --change='CMD ["/opt/IBM/JazzTeamServer/server/server.startup","-run"]' -c "EXPOSE 9443" myjts jts

docker rm myjts

docker run -d --name jts-app -p 9080:9080 -p 9443:9443 --net=host jts

