

mkdir /tmp/dockmount

## Ensure latest runtime parameters are copied to the docker share
cp ../jts/repotools-params /tmp/dockmount
cp ../jts/basicUserRegistry.xml /tmp/dockmount
cp ../jts/ldapUserRegistry.xml /tmp/dockmount

docker build --rm -t ccm-build .

docker run -it --name myccm --net=host -p 9080:9080 -p 9443:9443 -v /tmp/dockmount:/tmp/dockmount ccm-build /opt/IBM/JazzTeamServer/server/repotools-install.sh

docker commit --change='CMD ["/opt/IBM/JazzTeamServer/server/server.startup","-run"]' -c "EXPOSE 9443" myccm ccm

docker rm myccm

docker run -d --name ccm-app -p 9443:9443 --net=host ccm


