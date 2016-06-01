#!/bin/bash

export SQLSERVER_JDBC_DRIVER_FILE=/opt/sqljdbc/sqljdbc4.jar
export PATH=$PATH:/opt/IBM/JazzTeamServer/server/jre/bin

source /tmp/dockmount/repotools-params

ADMIN_PASSWORD_ENCODED=$(/opt/IBM/JazzTeamServer/server/liberty/wlp/bin/securityUtility encode ${ADMIN_PASSWORD})

## Edit the jts.response file to replace with variables.
echo "Evaluating response file"
template="$(cat /opt/IBM/JazzTeamServer/server/jts.response.tmpl)"
eval "echo \"${template}\"" > /tmp/jts.response

echo "Updating websphere liberty basic user registry file"

## Turn off basic registry
sed -i 's/<include location="conf\/basicUserRegistry.xml"\/>/<!-- include location="conf\/basicUserRegistry.xml"\/-->/g' /opt/IBM/JazzTeamServer/server/liberty/clmServerTemplate/server.xml

## Enable ldap registry
sed -i 's/<!--include location="conf\/ldapUserRegistry.xml"\/-->/<include location="conf\/ldapUserRegistry.xml"\/>/g' /opt/IBM/JazzTeamServer/server/liberty/clmServerTemplate/server.xml

## Update groups to be version with underscore instead.  I.e. Jazz_Admins instead of default JazzAdmins
sed -i 's/group name="Jazz/group name="Jazz_/g' /opt/IBM/JazzTeamServer/server/liberty/clmServerTemplate/conf/application.xml
sed -i 's/ProjectAdmins/Project_Admins/g' /opt/IBM/JazzTeamServer/server/liberty/clmServerTemplate/conf/application.xml

## Take the ldap configuration provided for Liberty and insert the variables from `repotools-params`
registryTemplate="$(cat /tmp/dockmount/ldapUserRegistry.xml)"
eval "echo \"${registryTemplate}\"" > /opt/IBM/JazzTeamServer/server/liberty/clmServerTemplate/conf/ldapUserRegistry.xml

## Take the basic configuration provided for Liberty and insert the variables from `repotools-params`
## ToDo: Might no longer be needed given basic registry is disabled.
basicRegistryTemplate="$(cat /tmp/dockmount/basicUserRegistry.xml)"
eval "echo \"${basicRegistryTemplate}\"" > /opt/IBM/JazzTeamServer/server/liberty/clmServerTemplate/conf/basicUserRegistry.xml

cd /opt/IBM/JazzTeamServer/server/

./server.startup

echo Starting setup using user: ${ADMIN_USER}
./repotools-jts.sh -setup repositoryURL=${JTS_SITE_URL}/jts adminUserID=${ADMIN_USER} adminPassword=${ADMIN_PASSWORD} parametersFile=/tmp/jts.response logFile=rtc.log

./server.shutdown

rm -rf /tmp/clm-installer/
rm -rf /tmp/im-repo/
rm -rf /tmp/silent-install/



